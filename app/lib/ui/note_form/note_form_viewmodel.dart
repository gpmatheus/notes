
import 'package:flutter/material.dart';
import 'package:notes/data/repository/implementations/content_repository.dart';
import 'package:notes/domain/model/note/note.dart';
import 'package:notes/domain/usecases/maintain_notes.dart';
import 'package:notes/ui/note_details/note_details_viewmodel.dart';
import 'package:notes/ui/note_details/widgets/note_details_view.dart';
import 'package:provider/provider.dart';

class NoteFormViewmodel {

  NoteFormViewmodel({
    required MaintainNotes maintainNotes,
    Note? note,
  }) :
    _maintainNotes = maintainNotes,
    _note = note {
      _textController = TextEditingController(text: note?.name);
    }

  final MaintainNotes _maintainNotes;
  final Note? _note;

  late final TextEditingController _textController;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<Note?> _createdNote = ValueNotifier(null);
  final ValueNotifier<bool> _displayResult = ValueNotifier(false);

  TextEditingController get textController => _textController;

  GlobalKey<FormState> get formKey => _formKey;

  ValueNotifier<bool> get loading => _loading;

  ValueNotifier<Note?> get createdNote => _createdNote;

  ValueNotifier<bool> get displayResult => _displayResult;

  bool get isCreating => _note == null;

  String? validateName(String? name) {
    return _valid(name) 
      ? null 
      : 'Invalid name.';
  }

  bool _valid(String? name) {
    return name != null && name.trim().isNotEmpty;
  }

  void send() async {
    if (_note == null) {
      await _createNote();
    } else {
      await _updateNote();
    }
  }

  Future<void> _createNote() async {
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

  Future<void> _updateNote() async {
    if (formKey.currentState != null) {
      bool valid = formKey.currentState!.validate();
      if (!valid) return;
      _loading.value = true;
      Note? updatedNote = await _maintainNotes.updateNote(_note!.id, _textController.text);
      _loading.value = false;
      _createdNote.value = updatedNote;
      _displayResult.value = true;
    }
  }

  Future<Object?> navigateToNoteDetails(BuildContext context) async {
    if (createdNote.value == null) return null;
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        final note = _createdNote.value!;
        final String noteId = note.id;
        return NoteScreen(
          viewModel: NoteDetailsViewmodel(
            noteId: noteId, 
            contentUseCase: context.read(), 
            contentRepository: context.read<ContentRepository>(), 
            maintainNotes: context.read(), 
            userRepository: context.read(), 
          ),
        );
      })
    );
  }
}