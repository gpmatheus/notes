
import 'package:notes/data/services/interfaces/model/note/note_dto.dart';

abstract class LocalNoteService {

  Future<NoteDto?> getNoteById(String contentId);
  Future<List<NoteDto>> getNotes();
  Future<NoteDto?> createNote(NoteDto noteDto);
  Future<NoteDto?> updateNote(String id, NoteDto noteDto);
  Future<void> deleteNote(String noteId);
}