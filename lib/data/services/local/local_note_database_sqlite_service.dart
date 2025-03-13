
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:notes/data/services/local/config/sqlite_database.dart';
import 'package:notes/data/services/interfaces/local_note_service.dart';
import 'package:notes/data/services/interfaces/model/exceptions/invalid_input_exception.dart';
import 'package:notes/data/services/interfaces/model/exceptions/not_found_exception.dart';
import 'package:notes/data/services/interfaces/model/note/note_dto.dart';

class LocalNoteDatabaseSqliteService implements LocalNoteService {

  LocalNoteDatabaseSqliteService({
    required this.database,
  });

  @protected
  final SqliteDatabase database;

  @override
  Future<NoteDto?> getNoteById(String id) async {
    var result = await (database.select(database.noteLocalModel)
        ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    if (result == null) throw NotFoundException('Note with id $id not found');
    return _convertToDto(result);
  }

  @override
  Future<List<NoteDto>> getNotes() async {
    var result = (await database.select(database.noteLocalModel).get());
    return [
      for (var i in result)
        _convertToDto(i)
    ];
  }

  @override
  Future<NoteDto?> createNote(NoteDto noteDto) async {
    if (noteDto.id.isEmpty) throw InvalidInputException('Note id cannot be empty');
    var unique = await (database.select(database.noteLocalModel)
        ..where((table) => table.id.equals(noteDto.id)))
        .getSingleOrNull() == null;
    if (!unique) throw InvalidInputException('Note with id ${noteDto.id} already exists');
    NoteLocalModelCompanion model = _convertToCompanion(noteDto);
    var result = await database.into(database.noteLocalModel).insertReturningOrNull(model);
    if (result == null) throw Exception('Something went wrong');
    return _convertToDto(result);
  }

  @override
  Future<NoteDto?> updateNote(String id, NoteDto noteDto) async {
    NoteLocalModelCompanion model = _convertToCompanion(noteDto);
    List<NoteDrift> result = await (database.update(database.noteLocalModel)
        ..where((table) => table.id.equals(id)))
        .writeReturning(model);
    if (result.isEmpty) throw NotFoundException('Note with id $id not found');
    final NoteDrift updated = result.first;
    return _convertToDto(updated);
  }

  @override
  Future<void> deleteNote(String noteId) async {
    var success = (await (database.delete(database.noteLocalModel)
        ..where((table) => table.id.equals(noteId))).go()) > 0;
    if (!success) throw NotFoundException('Note with id $noteId not found');
  }

  NoteLocalModelCompanion _convertToCompanion(NoteDto note) {
    return NoteLocalModelCompanion(
      id: Value(note.id),
      name: Value(note.name),
      createdAt: Value(note.createdAt),
      lastEdited: Value(note.lastEdited),
    );
  }

  NoteDto _convertToDto(NoteDrift note) {
    return NoteDto(
      id: note.id,
      name: note.name,
      createdAt: note.createdAt,
      lastEdited: note.lastEdited,
    );
  }
}