
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

class _NoteScreenState extends State<NoteScreen> {

  final ScrollController _scrollController = ScrollController();

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
                          key: ValueKey(content.id),
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
                                widget.viewModel.navigateToContentForm(
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
        onTypeSelected: (Types tp) { 
          widget.viewModel.navigateToContentForm(
            context: context,
            form: tp.form(
              context, 
              null, 
              _scrollController.offset, 
              widget.viewModel.note != null && widget.viewModel.note!.contents != null
              ? widget.viewModel.note!.contents!
              : [], 
              widget.viewModel.note!.id
            ),
          );
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

}