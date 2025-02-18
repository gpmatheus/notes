
import 'package:notes/domain/model/note/note.dart';

abstract class NoteRepositoryInterface {

  Future<Note?> insertNote(String noteName);
  Future<Note?> updateNote(String noteId, Note note);
  Future<bool> deleteNote(String noteId);
  Future<Note?> getNote(String noteId);
  Future<List<Note>> getNotes();
}