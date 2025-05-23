
import 'package:flutter/material.dart';
import 'package:notes/ui/core/content_frame.dart';
import 'package:notes/ui/note_details/note_details_viewmodel.dart';
import 'package:notes/ui/core/add_button.dart';
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

  @override
  void initState() {
    super.initState();

    widget.viewModel.addListener(() {
      setState(() { });
      if (widget.viewModel.showModal) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Text(widget.viewModel.modalMessage != null ? widget.viewModel.modalMessage! : ''),
              if (!widget.viewModel.modalSuccess) ... {
                const Icon(Icons.error),
              }
            ],
          ),
          showCloseIcon: true,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _navigateBack, 
          icon: const Icon(Icons.arrow_back_rounded)
        ),
        title: Text(widget.viewModel.note != null ? widget.viewModel.note!.name : ''),
        actions: [
          if (widget.viewModel.selectedContentIndex >= 0) ... [
            IconButton(
              icon: const Icon(Icons.delete_rounded),
              onPressed: () {
                widget.viewModel.deleteContent(
                  widget.viewModel.selectedContentIndex,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: () => widget.viewModel.editContent(widget.viewModel.selectedContentIndex),
            ),
          ] else ... [
            PopupMenuButton(
              onSelected: (value) { 
                switch (value) {
                  case 'edit':
                    widget.viewModel.navigateToNoteForm(context);
                    break;
                  case 'delete':
                    widget.viewModel.deleteNote().then((bool result) {
                      // ignore: use_build_context_synchronously
                      if (mounted && result) _navigateBack();
                    });
                    break;
                }
              }, 
              icon: const Icon(Icons.more_vert_rounded),
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                )
              ],
            )
          ],
        ],
      ),
      body: GestureDetector(
        onTap: () => widget.viewModel.selectContent(-1),
        child: LoadingScreen(
              screen: 
              (widget.viewModel.note != null && widget.viewModel.note!.contents!.isNotEmpty) || 
              (widget.viewModel.note != null && widget.viewModel.formType != null)
              ? Column(
                children: [
                  Expanded (
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ReorderableListView(
                        onReorder: (int oldIndex, int newIndex) {
                          widget.viewModel.switchPositions(oldIndex, newIndex);
                        },
                        shrinkWrap: true,
                        children: List.generate(
                          widget.viewModel.note!.contents!.length + 
                          (widget.viewModel.formType != null ? 1 : 0),
                          (index) {
                            if (index == widget.viewModel.note!.contents!.length && 
                              widget.viewModel.formType != null) {
                              return Container(
                                key: Key('$index'),
                                child: widget.viewModel.formType!.display(
                                  widget.viewModel.note!.id,
                                  null,
                                  index == widget.viewModel.formIndex, // se é form ou não
                                  index, // índice
                                  widget.viewModel.onContentUpdated,
                                  widget.viewModel.onCancel,
                                  widget.viewModel.onError,
                                )
                              );
                            }
                            final content = widget.viewModel.note!.contents![index];
                            return GestureDetector(
                              key: Key('$index'),
                              onDoubleTap: () => widget.viewModel.selectContent(index),
                              child: ContentFrame(
                                activated: index == widget.viewModel.selectedContentIndex,
                                content: content.type.display(
                                  widget.viewModel.note!.id,
                                  content, // conteúdo
                                  index == widget.viewModel.formIndex, // se é form ou não
                                  index, // índice
                                  widget.viewModel.onContentUpdated,
                                  widget.viewModel.onCancel,
                                  widget.viewModel.onError,
                                ),
                              ),
                            );
                          })
                      ),
                    ),
                  ),
                  const SizedBox(height: 60.0,),
                ],
              )
              : const Center(
                child: Text('No content'),
              ),
              loading: widget.viewModel.loading,
            ),
      ),
      floatingActionButton: AddButton(
        onTypeSelected: widget.viewModel.newContentForm,
      )
    );
  }

  void _navigateBack() {
    Navigator.pop(context, widget.viewModel.hasChanged);
  }

}