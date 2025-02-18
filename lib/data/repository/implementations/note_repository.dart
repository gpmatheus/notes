
import 'package:notes/data/repository/interfaces/note_repository_interface.dart';
import 'package:notes/data/services/local/interfaces/local_content_type_service.dart';
import 'package:notes/data/services/local/interfaces/local_note_service.dart';
import 'package:notes/data/services/local/interfaces/model/note/note_dto.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/note/note.dart';
import 'package:uuid/uuid.dart';

class NoteRepository implements NoteRepositoryInterface {

  NoteRepository({
    required LocalNoteService localNoteService,
    required List<LocalContentTypeService> localContentServices,
  }) : 
    _localNoteService = localNoteService;

  final LocalNoteService _localNoteService;


  @override
  Future<Note?> insertNote(String noteName) async {
    NoteDto? insertedNote = await _localNoteService.createNote(
      NoteDto(
        id: const Uuid().v4(), 
        name: noteName, 
        createdAt: DateTime.now(), 
        lastEdited: null,
      ),
    );
    if (insertedNote == null) return null;
    return _fromDto(insertedNote, []);
  }

  @override
  Future<Note?> updateNote(String noteId, Note note) async {
    NoteDto? updatedNote = await _localNoteService.updateNote(
      noteId, 
      NoteDto(
        id: note.id, 
        name: note.name, 
        createdAt: note.createdAt, 
        lastEdited: DateTime.now(),
      )
    );
    if (updatedNote == null) return null;
    return _fromDto(updatedNote, note.contents);
  }

  @override
  Future<bool> deleteNote(String noteId) async {
    bool deleted = await _localNoteService.deleteNote(noteId);
    return deleted;
  }

  @override
  Future<Note?> getNote(String noteId) async {
    NoteDto? noteDto = await _localNoteService.getNoteById(noteId);
    if (noteDto == null) return null;
    return _fromDto(noteDto, []);
  }

  @override
  Future<List<Note>> getNotes() async {
    List<NoteDto> result = await _localNoteService.getNotes();
    return [
      for (var res in result)
        _fromDto(res, null)
    ];
  }

  Note _fromDto(NoteDto note, List<Content>? contents) {
    return Note(
      id: note.id, 
      name: note.name, 
      contents: contents, 
      createdAt: note.createdAt, 
      lastEdited: note.lastEdited
    );
  }

}