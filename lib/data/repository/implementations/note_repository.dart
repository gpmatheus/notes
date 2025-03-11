
import 'package:logger/logger.dart';
import 'package:notes/data/repository/interfaces/note_repository_interface.dart';
import 'package:notes/data/services/local/interfaces/local_content_type_service.dart';
import 'package:notes/data/services/local/interfaces/local_note_service.dart';
import 'package:notes/data/services/local/interfaces/model/exceptions/invalid_input_exception.dart';
import 'package:notes/data/services/local/interfaces/model/exceptions/not_found_exception.dart';
import 'package:notes/data/services/local/interfaces/model/note/note_dto.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/note/note.dart';
import 'package:notes/utils/formatted_logger.dart';
import 'package:uuid/uuid.dart';

class NoteRepository implements NoteRepositoryInterface {

  NoteRepository({
    required LocalNoteService localNoteService,
    required List<LocalContentTypeService> localContentServices,
  }) : 
    _localNoteService = localNoteService;

  final LocalNoteService _localNoteService;
  final Logger _logger = FormattedLogger.instance;

  @override
  Future<Note?> insertNote(String noteName) async {
    try {
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
    } on InvalidInputException {
      rethrow;
    } on Exception catch (e) {
      _logger.e('Error inserting note: $e');
      return null;
    }
  }

  @override
  Future<Note?> updateNote(String noteId, String noteName) async {
    try {
      NoteDto? note = await _localNoteService.getNoteById(noteId);
      if (note == null) {
        _logger.e('Note could not be found');
        throw NotFoundException('Note could not be found');
      }
      NoteDto? updatedNote = await _localNoteService.updateNote(
        noteId, 
        NoteDto(
          id: note.id, 
          name: noteName, 
          createdAt: note.createdAt, 
          lastEdited: DateTime.now(),
        ),
      );
      if (updatedNote == null) return null;
      return _fromDto(updatedNote, null);
    } on InvalidInputException {
      rethrow;
    } on Exception catch (e) {
      _logger.e('Error updating note: $e');
      return null;
    }
  }

  @override
  Future<bool> deleteNote(String noteId) async {
    try {
      await _localNoteService.deleteNote(noteId);
      return true;
    } on InvalidInputException {
      rethrow;
    } on Exception catch (e) {
      _logger.e('Error deleting note: $e');
      return false;
    }
  }

  @override
  Future<Note?> getNote(String noteId) async {
    try {
      NoteDto? noteDto = await _localNoteService.getNoteById(noteId);
      if (noteDto == null) return null;
      return _fromDto(noteDto, []);
    } on InvalidInputException {
      rethrow;
    } on Exception catch (e) {
      _logger.e('Error getting note: $e');
      return null;
    }
  }

  @override
  Future<List<Note>> getNotes() async {
    try {
      List<NoteDto> result = await _localNoteService.getNotes();
      return [
        for (var res in result)
          _fromDto(res, null)
      ];
    } on InvalidInputException {
      rethrow;
    } on Exception catch (e) {
      _logger.e('Error getting notes: $e');
      return [];
    }
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