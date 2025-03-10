
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:notes/ui/note_form/note_form_viewmodel.dart';

class NoteForm extends StatelessWidget {

  const NoteForm({
    super.key,
    required NoteFormViewmodel viewModel,
  }) :
    _viewModel = viewModel;

  final NoteFormViewmodel _viewModel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _viewModel.loading,
      builder: (context, loading, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: _viewModel.displayResult,
          builder: (context, displayResult, child) {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context, null),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.5), 
                    ),
                  ),
                ),
                AlertDialog(
                  title: const Text('Create note'),
                  content: displayResult
                  ? (
                      _viewModel.createdNote.value != null
                      ? const Text('Note created!')
                      : const Text('Note could not be created.')
                    )
                  : (
                      loading
                      ? const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      )
                      : Form(
                          key: _viewModel.formKey,
                          child: TextFormField(
                            autofocus: true,
                            controller: _viewModel.textController,
                            validator: _viewModel.validateName,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Digite o nome aqui...',
                            ),
                          ),
                        )
                    ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context, 
                          displayResult && _viewModel.createdNote.value != null
                          ? _viewModel.createdNote.value
                          : null
                        );
                      }, 
                      child: Text(displayResult
                        ? 'Go back.'
                        : 'Cancel'
                      ),
                    ),
                    if (!displayResult && !loading) ... {
                      TextButton(
                        onPressed: () { 
                          _viewModel.createNote();
                        }, 
                        child: const Text('Create')
                      )
                    },
                    if (!displayResult && loading) ... {
                      TextButton(
                        onPressed: () { },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black26
                        ),
                        child: const Text('Created'),
                      )
                    },
                    if (displayResult && _viewModel.createdNote.value != null) ... {
                      TextButton(
                        onPressed: () { 
                          _viewModel.navigateToNoteDetails(context).then((_) {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop(_viewModel.createdNote.value);
                          });
                        },
                        child: const Text('See note'),
                      )
                    },
                  ],
                ),
              ],
            );
          }
        );
      }
    );
  }

}