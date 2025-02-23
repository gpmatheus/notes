
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:notes/data/services/local/implementations/config/sqlite_database.dart';
import 'package:notes/data/services/local/interfaces/local_note_service.dart';
import 'package:notes/data/services/local/interfaces/model/note/note_dto.dart';

class LocalDatabaseSqliteService implements LocalNoteService {

  LocalDatabaseSqliteService({
    required this.database,
  });

  @protected
  final SqliteDatabase database;

  @override
  Future<NoteDto?> getNoteById(String id) async {
    var result = await (database.select(database.noteLocalModel)
        ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    return _convertToDto(result);
  }

  @override
  Future<List<NoteDto>> getNotes() async {
    var result = (await database.select(database.noteLocalModel).get());
    return [
      for (var i in result)
        _convertToDto(i)!
    ];
  }

  @override
  Future<NoteDto?> createNote(NoteDto noteDto) async {
    if (noteDto.id.isEmpty) return null;
    var unique = await (database.select(database.noteLocalModel)
        ..where((table) => table.id.equals(noteDto.id)))
        .getSingleOrNull() == null;
    if (!unique) return null;
    NoteLocalModelCompanion? model = _convertToCompanion(noteDto);
    if (model == null) return null;
    var result = await database.into(database.noteLocalModel).insertReturning(model);
    return _convertToDto(result);
  }

  @override
  Future<NoteDto?> updateNote(String id, NoteDto noteDto) async {
    NoteLocalModelCompanion? model = _convertToCompanion(noteDto);
    if (model == null) return null;
    List<NoteDrift> result = await (database.update(database.noteLocalModel)
        ..where((table) => table.id.equals(id)))
        .writeReturning(model);
    NoteDrift? updated = result.isNotEmpty ? result.first : null;
    return _convertToDto(updated);
  }

  @override
  Future<bool> deleteNote(String noteId) async {
    return (await (database.delete(database.noteLocalModel)
        ..where((table) => table.id.equals(noteId))).go()) > 0;
  }

  NoteLocalModelCompanion? _convertToCompanion(NoteDto note) {
    return NoteLocalModelCompanion(
      id: Value(note.id),
      name: Value(note.name),
      createdAt: Value(note.createdAt),
      lastEdited: Value(note.lastEdited),
    );
  }

  NoteDto? _convertToDto(NoteDrift? note) {
    return note == null 
    ? null 
    : NoteDto(
      id: note.id,
      name: note.name,
      createdAt: note.createdAt,
      lastEdited: note.lastEdited,
    );
  }
}