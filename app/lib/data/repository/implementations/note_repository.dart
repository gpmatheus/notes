
import 'package:notes/data/repository/interfaces/note_repository_interface.dart';
import 'package:notes/data/services/interfaces/content_type_service.dart';
import 'package:notes/data/services/interfaces/note_service.dart';
import 'package:notes/data/services/interfaces/model/exceptions/invalid_input_exception.dart';
import 'package:notes/data/services/interfaces/model/exceptions/not_found_exception.dart';
import 'package:notes/data/services/interfaces/model/note/note_dto.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/note/note.dart';
import 'package:notes/domain/model/user/user.dart';
import 'package:uuid/uuid.dart';

class NoteRepository implements NoteRepositoryInterface {

  NoteRepository({
    required NoteService localNoteService,
    required NoteService remoteNoteService,
    required List<ContentTypeService> localContentServices,
  }) : 
    _localNoteService = localNoteService,
    _remoteNoteService = remoteNoteService;

  final NoteService _localNoteService;
  final NoteService _remoteNoteService;

  @override
  Future<Note> insertNote(String noteName, User? user) async {

    NoteDto newNote = NoteDto(
      id: const Uuid().v4(), 
      name: noteName, 
      createdAt: DateTime.now(), 
      lastEdited: null,
    );
    try {
      NoteDto insertedNote = await _localNoteService.createNote(newNote);
      if (user != null && user.remoteSave) {
        await _remoteNoteService.createNote(newNote);
      }
      return _fromDto(insertedNote, []);
    } on InvalidInputException {
      rethrow;
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<Note> updateNote(String noteId, String noteName, User? user) async {
    try {
      NoteDto note = await _localNoteService.getNoteById(noteId);
      NoteDto newNote = NoteDto(
        id: note.id, 
        name: noteName, 
        createdAt: note.createdAt, 
        lastEdited: DateTime.now(),
      );
      NoteDto? updatedNote = await _localNoteService.updateNote(
        noteId, 
        newNote,
      );
      if (user != null && user.remoteSave) {
        await _remoteNoteService.updateNote(
          noteId, 
          newNote,
        );
      }
      return _fromDto(updatedNote, null);
    } on InvalidInputException catch (_) {
      rethrow;
    } on NotFoundException catch (_) {
      rethrow;
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteNote(String noteId, User? user) async {
    try {
      await _localNoteService.deleteNote(noteId);
      if (user != null && user.remoteSave) {
        await _remoteNoteService.deleteNote(noteId);
      }
      return true;
    } on InvalidInputException {
      rethrow;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Future<Note> getNote(String noteId, User? user) async {
    try {
      NoteDto noteDto = await _localNoteService.getNoteById(noteId);
      if (user != null && user.remoteSave) {
        await _remoteNoteService.deleteNote(noteId);
      }
      return _fromDto(noteDto, []);
    } on InvalidInputException {
      rethrow;
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<Note>> getNotes(User? user) async {
    try {
      List<NoteDto> result;
      if (user == null || !user.remoteSave) {
        result = await _localNoteService.getNotes();
      } else {
        result = await _remoteNoteService.getNotes();
      }
      return [
        for (var res in result)
          _fromDto(res, null)
      ];
    } on InvalidInputException {
      rethrow;
    } on Exception catch (_) {
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