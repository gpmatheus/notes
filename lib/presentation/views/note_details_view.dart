
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/domain/contents/content_types.dart';
import 'package:notes/domain/entities/content.dart';
import 'package:notes/domain/entities/note.dart';
import 'package:notes/domain/usecases/maintain_notes.dart';
import 'package:notes/domain/usecases/manage_contents.dart';
import 'package:notes/presentation/widgets/add_button_layer.dart';
import 'package:notes/presentation/widgets/content_container.dart';
import 'package:notes/presentation/widgets/loading_screen.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({
    super.key, 
    this.note, 
    required this.noteId, 
    required this.readNotesUsecase, 
    required this.manageContents}
  );

  final Note? note;
  final String noteId;
  final MaintainNotes readNotesUsecase;
  final ManageContents manageContents;
  
  @override
  State<StatefulWidget> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  Note? _note;
  bool _loading = false;
  List<Content>? _contents;
  final ScrollController _scrollController = ScrollController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy - HH:mm');

  @override
  void initState() {
     super.initState();

     _note = widget.note;
     if (_note == null || _note!.contents == null) {
      setState(() {
        _loading = true;
      });
      widget.readNotesUsecase.getNote(widget.noteId).then((note) {
        setState(() {
          _note = note;
          if (_note != null) _contents = _note!.contents;
          _loading = false;
        });
      });
     }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: LoadingScreen(
        screen: _bodyContent(),
        loading: _loading
      ),
      floatingActionButton: AddButton(
        onTypeSelected: (ContentsType ct) => _onContentSelected(context, ct)
      )
    );
  }

  PreferredSizeWidget _getAppBar() {
    return AppBar(
      title: Text(_note != null ? _note!.name : ''),
      actions: _getAppBarActions(),
    );
  }

  List<Widget>? _getAppBarActions() {
    return null;
    // return [
    //   PopupMenuButton<String>(
    //     icon: const Padding(
    //       padding: EdgeInsets.all(16.0),
    //       child: Icon(Icons.more_vert_rounded),
    //     ), 
    //     itemBuilder: (BuildContext context) => [
    //       {
    //         'icon': const Icon(Icons.edit_rounded),
    //         'text': 'Edit',
    //         'value': 'edit',
    //         'func': () { },
    //       },
    //       {
    //         'icon': const Icon(Icons.delete_rounded),
    //         'text': 'Delete',
    //         'value': 'delete',
    //         'func': () { },
    //       },
    //     ].map((option) {
    //       return PopupMenuItem(
    //         value: option['value'] as String,
    //         child: TextButton(
    //           onPressed: () { },
    //           child: Row(
    //             children: [
    //               option['icon'] as Icon,
    //               const SizedBox(width: 10,),
    //               Text(option['text'] as String),
    //             ],
    //           ),
    //         )
    //       );
    //     }).toList(),
    //   )
    // ];
  }

  Widget _bodyContent() {

    return (_contents != null && _contents!.isNotEmpty)
      ? Column(
        children: [
          Expanded (
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _contents!.length,
                itemBuilder: (context, index) {
                  final content = _contents![index];
                  return ContentContainer(
                    actions: [
                      ContainerActions(
                        icon: const Icon(Icons.delete_rounded), 
                        name: 'Delete', 
                        callback: (Content content) {
                          _deleteContent(context, content, index);
                        }
                      ),
                      ContainerActions(
                        icon: const Icon(Icons.edit_rounded), 
                        name: 'Edit', 
                        callback: (Content con) async {
                          final Content? resCont = await _navigateToForm(
                            context, 
                            con.contentsType()
                              .form(null, con, _contents != null ? _contents! : [], _scrollController)
                          );
                          // ignore: use_build_context_synchronously
                          if (resCont != null && mounted) _editContent(context, resCont, index);
                        }
                      ),
                    ],
                    content: content,
                    contentWidget: content.contentsType().displayer(widget.key, content),
                    header: content.lastEdited == null 
                      ? 'Criado em ${_dateFormat.format(content.createdAt)}'
                      : 'Editado em ${_dateFormat.format(content.lastEdited!)}'
                  );
                }
              ),
            ),
          ),
          const SizedBox(height: 30.0,)
        ],
      )
      : const Center(
        child: Text('No content'),
      );
  }

  void _deleteContent(BuildContext context, Content content, int index) async {
    setState(() {
      _loading = true;
    });
    final bool deleted = await widget.manageContents.deleteContent(content);
    setState(() {
      _loading = false;
    });
    if (mounted) {
      showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          setState(() {
            if (deleted) _contents!.removeAt(index);
          });
        });
        return AlertDialog(
          title: Text(deleted ? 'Content deleted.' : 'Content could not be deleted.'),
        );
      }
    );
    }
  }

  void _editContent(BuildContext context, Content content, int index) async {
    setState(() {
      _loading = true;
    });
    final Content? resultContent = await widget
      .manageContents.editContent(_contents![index].id, content);
    setState(() {
      _loading = false;
    });
    if (mounted) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context, 
        builder: (context) {
          Future.delayed(const Duration(seconds: 2), () {
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            setState(() {
              if (resultContent != null) _contents![index] = resultContent;
            });
          });
          return AlertDialog(
            title: Text(resultContent != null ? '${content.contentsType().name} updated.': 'Content could not be updated.')
          );
        }
      );
    }
  }

  void _onContentSelected(BuildContext context, ContentsType ct) async {
    Content? resultContent = await _navigateToForm(
      context, 
      ct.form(null, null, _contents != null ? _contents! : [], _scrollController)
    );
    if (resultContent != null) {
      setState(() {
        _loading = true;
      });
      resultContent = await widget.manageContents.createContent(widget.noteId, resultContent);
      setState(() {
        if (resultContent != null) {
          _contents ??= [];
          _contents!.add(resultContent);
        }
        _loading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // await Future.delayed(const Duration(microseconds: 500));
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent, 
          duration: const Duration(seconds: 1), 
          curve: Curves.easeOut
        );
      });
    }
  }

  Future<Content?> _navigateToForm(BuildContext context, Widget wchild) async {
    return await Navigator.push(
      context, 
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return wchild;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      )
    );
  }

}