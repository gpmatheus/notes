
import 'package:flutter/material.dart';
import 'package:notes/domain/entities/note.dart';
import 'package:notes/domain/usecases/maintain_notes.dart';
import 'package:notes/presentation/views/note_details_view.dart';
import 'package:notes/presentation/views/note_form.dart';

class HomeViewmodel {

  final MaintainNotes _maintainNotesUsecase = MaintainNotes.instance;

  final ValueNotifier<List<Note>?> _notes = ValueNotifier(null);
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<HomeFields> _fields = ValueNotifier(
    HomeFields(
      notes: null,
      loading: false,
    )
  );

  HomeViewmodel() {
    _notes.addListener(_updateFields);
    _loading.addListener(_updateFields);
    loadNotes();
  }

  ValueNotifier<List<Note>?> get notes => _notes;

  ValueNotifier<bool> get loading => _loading;

  ValueNotifier<HomeFields> get fields => _fields;

  void loadNotes() async {
    _loading.value = true;
    _notes.value = await _maintainNotesUsecase.getAllNotes();
    _loading.value = false;
  }

  void navigateToNoteCreation(BuildContext context) async {
    Note? createdNote = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: NoteForm(),
          );
        }
      )
    );
    if (createdNote != null) {
      final List<Note> notes = _notes.value != null ? [... _notes.value!] : [];
      notes.add(createdNote);
      _notes.value = notes;
    }
  }

  void navigateToNoteDetails(BuildContext context, String noteId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return NoteScreen(
          noteId: noteId,
        );
      })
    );
  }

  void dispose() {
    _notes.dispose();
    _loading.dispose();
    _fields.dispose();
  }

  void _updateFields() {
    _fields.value = HomeFields(
      notes: _notes.value, 
      loading: _loading.value,
    );
  }
}

class HomeFields {
  HomeFields({required this.notes, required this.loading});
  final List<Note>? notes;
  final bool loading;
}