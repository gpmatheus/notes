
import 'package:notes/config/configurations/sqlite_config.dart';
import 'package:notes/data/datasources/interfaces.dart';
import 'package:notes/domain/entities/note.dart';
import 'package:sqflite/sqflite.dart';

class NoteLocalDataSourceImpl extends NoteDataSource {

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
      'created_at': createdAt as String,
      'last_edited': lastEdited as String?,
    } = res.first;

    return Note(
      id: id,
      name: name,
      contents: null,
      createdAt: DateTime.tryParse(createdAt),
      lastEdited: lastEdited != null ? DateTime.tryParse(lastEdited) : null,
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

  @override
  Future<bool> switchPosition(String noteId, int oldIndex, int newIndex) async {
    try {
      await _database.transaction((txn) async {
        final Map<String, Object?> oldIndexRes = (await txn.query(
          'content',
          where: 'position = ?',
          whereArgs: [oldIndex],
        )).first;
        final String oldIndexId = oldIndexRes['id'] as String;

        final Map<String, Object?> newIndexRes = (await txn.query(
          'content',
          where: 'position = ?',
          whereArgs: [newIndex],
        )).first; 
        final String newIndexId = newIndexRes['id'] as String;

        // altera os valores de ordem

        int effected = 0;

        // altera o valor da nova posição, colocando o valor velho
        effected = await txn.update(
          'content',
          {
            'position': oldIndex
          },
          where: 'id = ?',
          whereArgs: [newIndexId]
        );
        if (effected == 0) throw Exception('Error');

        // altera o valor na posição velha, colocando o valor da nova
        effected = await txn.update(
          'content',
          {
            'position': newIndex
          },
          where: 'id = ?',
          whereArgs: [oldIndexId]
        );
        if (effected == 0) throw Exception('Error');
      });
      return true;
    } catch (e) {
      return false;
    }
  }
  
}
