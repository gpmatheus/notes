
import 'package:flutter/material.dart';
import 'package:notes/domain/model/note/note.dart';
import 'package:notes/domain/usecases/maintain_notes.dart';
import 'package:notes/ui/note_details/note_details_viewmodel.dart';
import 'package:notes/ui/note_details/widgets/note_details_view.dart';
import 'package:notes/ui/note_form/note_form_viewmodel.dart';
import 'package:notes/ui/note_form/widgets/note_form.dart';
import 'package:provider/provider.dart';

class HomeViewmodel extends ChangeNotifier {

  HomeViewmodel({
    required MaintainNotes maintainNotes,
  }) :
    _maintainNotes = maintainNotes {
      loadNotes();
    }

  final MaintainNotes _maintainNotes;

  List<Note>? _notes;
  bool _loading = false;

  List<Note>? get notes => _notes;
  bool get loading => _loading;

  void loadNotes() async {
    _loading = true;
    notifyListeners();
    _notes = await _maintainNotes.getAllNotes();
    _loading = false;
    notifyListeners();
  }

  void navigateToNoteCreation(BuildContext context) async {
    Note? createdNote = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: NoteForm(
              viewModel: NoteFormViewmodel(
                maintainNotes: context.read(),
              ),
            ),
          );
        }
      )
    );
    if (createdNote != null) {
      final List<Note> notes = _notes != null ? [... _notes!] : [];
      notes.add(createdNote);
      _notes = notes;
      notifyListeners();
    }
  }

  void navigateToNoteDetails(BuildContext context, String noteId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return NoteScreen(
          viewModel: NoteDetailsViewmodel(
            noteId: noteId, 
            contentUseCase: context.read(), 
            contentRepository: context.read(), 
            maintainNotes: context.read(), 
          )
        );
      })
    );
  }

}