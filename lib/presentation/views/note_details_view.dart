
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/domain/contents/content_types.dart';
import 'package:notes/domain/entities/content.dart';
import 'package:notes/domain/entities/note.dart';
import 'package:notes/presentation/utils/actions_content.dart';
import 'package:notes/presentation/viewmodels/note_details_viewmodel.dart';
import 'package:notes/presentation/widgets/add_button.dart';
import 'package:notes/presentation/widgets/content_container.dart';
import 'package:notes/presentation/widgets/loading_screen.dart';

class NoteScreen extends StatefulWidget {
  final NoteDetailsViewmodel noteDetailsViewmodel;

  NoteScreen({
    super.key,
    required String noteId,
    Note? note,
  })
    : noteDetailsViewmodel = NoteDetailsViewmodel(noteId: noteId, note: note);
  
  @override
  State<StatefulWidget> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy - HH:mm');

  @override
  void initState() {
    super.initState();
    widget.noteDetailsViewmodel.showContentCreationResult.addListener(_displayContentCreationResult);
    widget.noteDetailsViewmodel.showContentEditionResult.addListener(_displayContentEditionResult);
    widget.noteDetailsViewmodel.showContentDeletedResult.addListener(_displayContentDeletedResult);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<NoteDetailsFields?>(
      valueListenable: widget.noteDetailsViewmodel.fields,
      builder: (context, values, _) {
        final Note? note = values!.note;
        final bool loading = values.loading;
        return Scaffold(
          appBar: AppBar(
            title: Text(note != null ? note.name : ''),
          ),
          body: LoadingScreen(
            screen: (widget.noteDetailsViewmodel.contents.value != null && 
              widget.noteDetailsViewmodel.contents.value!.isNotEmpty)
            ? Column(
              children: [
                Expanded (
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ReorderableListView(
                      onReorder: (int oldIndex, int newIndex) {
                        widget.noteDetailsViewmodel.switchPositions(oldIndex, newIndex);
                      },
                      scrollController: widget.noteDetailsViewmodel.scrollController,
                      shrinkWrap: true,
                      children: List.generate(widget.noteDetailsViewmodel.contents.value!.length, (index) {
                        final content = widget.noteDetailsViewmodel.contents.value![index];
                        return ContentContainer(
                          key: ValueKey(content.id),
                          actions: [
                            ActionsContent(
                              icon: const Icon(Icons.delete_rounded), 
                              name: 'Delete', 
                              onClick: (Content con) {
                                widget.noteDetailsViewmodel.deleteContent(context, con, index);
                              }
                            ),
                            ActionsContent(
                              icon: const Icon(Icons.edit_rounded), 
                              name: 'Edit', 
                              onClick: (Content con) async {
                                widget.noteDetailsViewmodel.editContent(context, con, index);
                              }
                            ),
                          ],
                          content: content,
                          contentWidget: content.contentsType().displayer(widget.key, content),
                          header: content.lastEdited == null 
                            ? 'Criado em ${_dateFormat.format(content.createdAt)}'
                            : 'Editado em ${_dateFormat.format(content.lastEdited!)}'
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
            loading: loading,
          ),
          floatingActionButton: AddButton(
            onTypeSelected: (ContentsType ct) { 
              widget.noteDetailsViewmodel.createContent(context, ct);
            }
          )
        );
      }
    );
  }

  void _displayContentCreationResult() {
    final ResultContent? resultContent = widget.noteDetailsViewmodel.contentCreationRes;
    if (!widget.noteDetailsViewmodel.showContentCreationResult.value) return;
    if (resultContent != null && resultContent.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.noteDetailsViewmodel.scrollController!.animateTo(
          widget.noteDetailsViewmodel.scrollController!.position.maxScrollExtent, 
          duration: const Duration(seconds: 1), 
          curve: Curves.easeOut
        ).then((_) {
          widget.noteDetailsViewmodel.showContentCreationResult.value = false;
        });
      });
    }
  }

  void _displayContentEditionResult() {
    final ResultContent? resultContent = widget.noteDetailsViewmodel.contentEditionRes;
    if (!widget.noteDetailsViewmodel.showContentEditionResult.value) return;
    if (resultContent != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text(resultContent.message),
              resultContent.success 
              ? const Icon(
                  Icons.check_rounded,
                  color: Colors.green,
                )
              : Icon(
                  Icons.error_rounded,
                  color: Colors.red.shade300
                )
            ],
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        )
      ).closed.then((_) {
        widget.noteDetailsViewmodel.showContentEditionResult.value = false;
      });
    }
  }

  void _displayContentDeletedResult() {
    final ResultContent? resultContent = widget.noteDetailsViewmodel.contentDeletedRes;
    if (!widget.noteDetailsViewmodel.showContentDeletedResult.value) return;
    if (resultContent != null) {
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  resultContent.message,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!resultContent.success || true) ... {
                  const Icon(
                    Icons.error_rounded,
                    size: 80,
                    color: Colors.green,
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
      ).then(
        (_) => widget.noteDetailsViewmodel.showContentDeletedResult.value = false
      );
    }
  }

}