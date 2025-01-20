
import 'package:notes/config/configurations/sqlite_config.dart';
import 'package:notes/data/datasources/interfaces.dart';
import 'package:notes/domain/entities/note.dart';
import 'package:sqflite/sqflite.dart';

class NoteLocalDataSourceImpl implements NoteDataSource {

  final Database _database = SqliteHelper.instance.database!;

  @override
  Future<Note> createNote(Note note) async {
    await _database.insert(
      'note',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return note;
  }

  @override
  Future<bool> deleteNote(String noteId) async {
    int effected = await _database.delete(
      'note',
      where: 'id = ?',
      whereArgs: [noteId],
    );
    return effected > 0;
  }

  @override
  Future<Note?> getNote(String noteId) async {
    List<Map<String, Object?>> res = await _database.query(
      'note',
      where: 'id = ?',
      whereArgs: [noteId],
    );
    if (res.isEmpty) return null;

    final {
      'id': id as String,
      'name': name as String,
      'created_at': createdAt as DateTime,
      'last_edited': lastEdited as DateTime,
    } = res.first;

    return Note(
      id: id,
      name: name,
      contents: null,
      createdAt: createdAt,
      lastEdited: lastEdited
    );
  }

  @override
  Future<List<Note>> getNotes() async {
    List<Map<String, Object?>> res = await _database.query('note');
    return [
      for (final {
        'id': id as String,
        'name': name as String,
        'created_at': createdAt as String,
        'last_edited': lastEdited as String?,
      } in res)
      Note(
        id: id,
        name: name,
        contents: null,
        createdAt: DateTime.tryParse(createdAt),
        lastEdited: lastEdited != null ? DateTime.tryParse(lastEdited) : null,
      )
    ];
  }

  @override
  Future<Note?> updateNote(String noteId, Note note) async {
    int effected = await _database.update(
      'note',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [noteId]
    );
    if (effected == 0) return null;
    return note;
  }
  
}
