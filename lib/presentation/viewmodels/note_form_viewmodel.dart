
import 'package:flutter/material.dart';
import 'package:notes/domain/entities/note.dart';
import 'package:notes/domain/usecases/maintain_notes.dart';
import 'package:notes/presentation/views/note_details_view.dart';

class NoteFormViewmodel {

  final MaintainNotes _maintainNotes = MaintainNotes.instance;

  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<Note?> _createdNote = ValueNotifier(null);
  final ValueNotifier<bool> _displayResult = ValueNotifier(false);

  TextEditingController get textController {
    return _textController;
  }

  GlobalKey<FormState> get formKey {
    return _formKey;
  }

  ValueNotifier<bool> get loading {
    return _loading;
  }

  ValueNotifier<Note?> get createdNote {
    return _createdNote;
  }

  ValueNotifier<bool> get displayResult {
    return _displayResult;
  }

  String? validateName(String? name) {
    return _valid(name) 
      ? null 
      : 'Invalid name.';
  }

  bool _valid(String? name) {
    return name != null && name.trim().isNotEmpty;
  }

  void createNote() async {
    if (formKey.currentState != null) {
      bool valid = formKey.currentState!.validate();
      if (!valid) return;
      _loading.value = true;
      Note? createdNote = await _maintainNotes.createNote(_textController.text);
      _loading.value = false;
      _createdNote.value = createdNote;
      _displayResult.value = true;
    }
  }

  Future<Object?> navigateToNoteDetails(BuildContext context) async {
    if (createdNote.value == null) return null;
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        final note = _createdNote.value!;
        final String noteId = note.id;
        return NoteScreen(noteId: noteId, note: note);
      })
    );
  }
}