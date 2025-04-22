
import 'package:notes/domain/model/note/note.dart';
import 'package:notes/domain/model/user/user.dart';

abstract class NoteRepositoryInterface {

  Future<Note> insertNote(String noteName, User? user);
  Future<Note> updateNote(String noteId, String noteName, User? user);
  Future<bool> deleteNote(String noteId, User? user);
  Future<Note> getNote(String noteId, User? user);
  Future<List<Note>> getNotes(User? user);
}