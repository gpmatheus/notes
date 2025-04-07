
import 'package:notes/data/repository/interfaces/note_repository_interface.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/note/note.dart';
import 'package:notes/domain/usecases/manage_contents.dart';

class MaintainNotes {

  MaintainNotes({
    required NoteRepositoryInterface noteRepository,
    required ManageContents manageContents,
  }) : 
    _noteRepository = noteRepository,
    _manageContents = manageContents;

  final NoteRepositoryInterface _noteRepository;
  final ManageContents _manageContents;

  Future<List<Note>> getAllNotes() async {
    return await _noteRepository.getNotes();
  }

  Future<Note?> getNote(String noteId) async {
    Note? note = await _noteRepository.getNote(noteId);
    if (note == null) return null;
    List<Content> contents = await _manageContents.getContents(noteId);
    if (note.contents != null) note.contents!.addAll(contents);
    return note;
  }

  Future<Note?> createNote(String name) async {
    return _noteRepository.insertNote(name);
  }

  Future<Note?> updateNote(String noteId, String name) async {
    return _noteRepository.updateNote(noteId, name);
  }

  Future<bool> deleteNote(String noteId) async {
    return _noteRepository.deleteNote(noteId);
  }

}