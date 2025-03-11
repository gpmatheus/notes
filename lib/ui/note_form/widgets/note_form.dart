
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
                  title: Text(_viewModel.isCreating ? 'Create note' : 'Update note'),
                  content: displayResult
                  ? (
                      _viewModel.createdNote.value != null
                      ? Text(_viewModel.isCreating ? 'Note created!' : 'Note updated!')
                      : Text(_viewModel.isCreating ? 'Note could not be created.' : 'Note could not be updated')
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
                              hintText: 'Type the note name here...',
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
                          _viewModel.send();
                        }, 
                        child: Text(_viewModel.isCreating ? 'Create' : 'Update')
                      )
                    },
                    if (!displayResult && loading) ... {
                      TextButton(
                        onPressed: () { },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black26
                        ),
                        child: Text(_viewModel.isCreating ? 'Created' : 'Updated'),
                      )
                    },
                    if (displayResult && _viewModel.createdNote.value != null) ... {
                      TextButton(
                        onPressed: () {
                          _viewModel.navigateToNoteDetails(context).then((_) {
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, _viewModel.createdNote.value);
                          });
                        },
                        child: Text(_viewModel.isCreating ? 'See note' : 'Ok'),
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