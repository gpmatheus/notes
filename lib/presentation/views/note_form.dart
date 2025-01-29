
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:notes/presentation/viewmodels/note_form_viewmodel.dart';

class NoteForm extends StatelessWidget {

  final NoteFormViewmodel _noteFormViewmodel = NoteFormViewmodel();

  NoteForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _noteFormViewmodel.loading,
      builder: (context, loading, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: _noteFormViewmodel.displayResult,
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
                      _noteFormViewmodel.createdNote.value != null
                      ? const Text('Note created!')
                      : const Text('Note could not be created.')
                    )
                  : (
                      loading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Form(
                          key: _noteFormViewmodel.formKey,
                          child: TextFormField(
                            autofocus: true,
                            controller: _noteFormViewmodel.textController,
                            validator: _noteFormViewmodel.validateName,
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
                          displayResult && _noteFormViewmodel.createdNote.value != null
                          ? _noteFormViewmodel.createdNote.value
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
                          _noteFormViewmodel.createNote();
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
                    if (displayResult && _noteFormViewmodel.createdNote.value != null) ... {
                      TextButton(
                        onPressed: () { 
                          _noteFormViewmodel.navigateToNoteDetails(context).then((_) {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop(_noteFormViewmodel.createdNote.value);
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