
import 'package:flutter/material.dart';
import 'package:notes/config/types.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/note/note.dart';
import 'package:notes/ui/note_details/note_details_viewmodel.dart';
import 'package:notes/ui/core/add_button.dart';
import 'package:notes/ui/core/content_container.dart';
import 'package:notes/ui/core/loading_screen.dart';

class NoteScreen extends StatefulWidget {

  const NoteScreen({
    super.key,
    required this.viewModel,
  });

  final  NoteDetailsViewmodel viewModel;
  
  @override
  State<StatefulWidget> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> with SingleTickerProviderStateMixin {

  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<GlobalKey>? _keys;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: _animationController, 
        curve: Curves.easeInOut,
      )
    );

    widget.viewModel.addListener(() {
      if (widget.viewModel.note != null) {
        if (_keys == null) {
          _keys = [
            for (int i = 0; i < widget.viewModel.note!.contents!.length; i++)
              GlobalKey()
          ];
        } else if (_keys!.length != widget.viewModel.note!.contents!.length) {
          _keys!.add(GlobalKey());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            return Text(widget.viewModel.note != null ? widget.viewModel.note!.name : '');
          }
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          final Note? note = widget.viewModel.note;
          _displayContentDeletedResult(
            widget.viewModel.showContentDeletedResult,
            widget.viewModel.deletedSuccess,
          );
          return LoadingScreen(
            screen: (note != null && note.contents != null && note.contents!.isNotEmpty)
            ? Column(
              children: [
                Expanded (
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ReorderableListView(
                      onReorder: (int oldIndex, int newIndex) {
                        widget.viewModel.switchPositions(oldIndex, newIndex);
                      },
                      scrollController: _scrollController,
                      shrinkWrap: true,
                      children: List.generate(note.contents!.length, (index) {
                        final content = note.contents![index];
                        return ContentContainer(
                          key: _keys![index],
                          actions: [
                            ActionsContent(
                              icon: const Icon(Icons.delete_rounded), 
                              name: 'Delete', 
                              onTap: (Content con) {
                                widget.viewModel.deleteContent(context, con, index);
                              }
                            ),
                            ActionsContent(
                              icon: const Icon(Icons.edit_rounded), 
                              name: 'Edit', 
                              onTap: (Content con) async {
                                Content? editedContent = await widget.viewModel.navigateToContentForm(
                                  content: con, 
                                  context: context, 
                                  form: content.type.form(
                                    context, 
                                    content, 
                                    _scrollController.offset, 
                                    note.contents!, 
                                    widget.viewModel.note!.id
                                  ),
                                );
                                if (editedContent != null) _animateEditedContent(index);
                              }
                            ),
                          ],
                          content: content,
                          contentWidget: content.type.display(content),
                        );
                      })
                    ),
                  ),
                ),
                const SizedBox(height: 30.0,)
              ],
            )
            : const Center(
              child: Text('No content'),
            ),
            loading: widget.viewModel.loading,
          );
        }
      ),
      floatingActionButton: AddButton(
        onTypeSelected: (Types tp) async { 
          Content? con = await widget.viewModel.navigateToContentForm(
            context: context,
            form: tp.form(
              context, 
              null, 
              _scrollController.hasClients ? _scrollController.offset : null, 
              widget.viewModel.note != null && widget.viewModel.note!.contents != null
              ? widget.viewModel.note!.contents!
              : [], 
              widget.viewModel.note!.id
            ),
          );
          if (con != null) _animateCreatedContent();
        }
      )
    );
  }

  void _displayContentDeletedResult(bool showContentDeletedResult, bool success) async {
    if (!showContentDeletedResult) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  success ? 'Content deleted.' : 'Content could not be deleted.',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!success) ... {
                  const Icon(
                    Icons.error_rounded,
                    size: 80,
                    color: Colors.red,
                  )
                }
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(), 
                child: const Text('Ok')
              )
            ],
          );
        }
      );

      // esconde o modal
      widget.viewModel.hideContentDeletionResult();
    });
  }

  void _animateEditedContent(int index) {
    final RenderBox renderBox = _keys![index].currentContext!.findRenderObject() as RenderBox;
    final double itemHeight = renderBox.size.height;
    final double viewportHeight = MediaQuery.of(context).size.height;
    final double offset = _calculateOffset(index, itemHeight, viewportHeight);

    _centerWidget(offset);
  }

  void _animateCreatedContent() {
    final double offset = 
    (_scrollController.hasClients ? _scrollController.position.maxScrollExtent : 0.0) +
    (MediaQuery.of(context).size.height / 4);

    _centerWidget(offset);
  }

  void _centerWidget(double offset) {

    _animation = Tween<double>(
      begin:  (_scrollController.hasClients ? _scrollController.position.maxScrollExtent : 0.0), 
      end: offset,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward(from: 0);
    if (_scrollController.hasClients) {
      _animation.addListener(() {
        _scrollController.jumpTo(_animation.value);
      });
      _scrollController.animateTo(offset, 
        duration: const Duration(seconds: 3), 
        curve: Curves.easeInOut,
      );
    }
  }

  double _calculateOffset(int index, double itemHeight, double viewportHeight) {
    double offset = 0;
    for (int i = 0; i < index; i++) {
      final RenderBox renderBox = _keys![i].currentContext!.findRenderObject() as RenderBox;
      offset += renderBox.size.height;
    }
    offset = offset - (viewportHeight / 2) + itemHeight;
    if (offset < 0.0) {
      offset = 0.0;
    } 
    return offset;
  }

}