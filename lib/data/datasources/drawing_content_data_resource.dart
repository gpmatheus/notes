
import 'package:notes/config/configurations/sqlite_config.dart';
import 'package:notes/data/datasources/interfaces.dart';
import 'package:notes/domain/entities/content.dart';
import 'package:sqflite/sqflite.dart';

class DrawingContentDataResource extends ContentDataSource {

  final Database _database = SqliteHelper.instance.database!;

  @override
  Future<Content> createContent(String noteId, Content content) async {
    await _database.insert(
      'content',
      {
        ...content.toParentMap(),
        'note_id': noteId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    content as DrawingContent;
    await _database.insert(
      'drawing_content',
      content.toChildMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return content;
  }

  @override
  Future<List<Content>> getContents(String noteId) async {
    const String query = """
        SELECT 
        child.drawing AS content_field, 
        child.content_id AS id, 
        con.created_at AS created_at, 
        con.last_edited AS last_edited
        FROM drawing_content AS child
        INNER JOIN content AS con ON child.content_id = con.id
        WHERE con.note_id = ?
        ORDER BY created_at ASC;
      """;
    List<Map<String, Object?>> results = await _database.rawQuery(
      query,
      [noteId]
    );
    return [
      for (final {
        'id': id as String,
        'created_at': createdAt as String,
        'last_edited': lastEdited as String?,
        'content_field': drawing as String,
      } in results)
      DrawingContent.existing(
        id: id, 
        createdAt: DateTime.tryParse(createdAt), 
        lastEdited: lastEdited != null ? DateTime.tryParse(lastEdited) : null, 
        draw: drawing
      )
    ];
  }

  @override
  Future<Content?> updateContent(String contentId, Content content) async {
    content as DrawingContent;
    int effected = await _database.update(
      'drawing_content',
      {
        'image_url': content.drawing,
      },
      where: 'content_id = ?',
      whereArgs: [contentId]
    );
    if (effected > 0) {
      await _database.update(
        'content',
        {
          'last_edited': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [contentId]
      );
    }
    return effected > 0 ? content : null;
  }
  
  @override
  Future<bool> deleteContent(String contentId) async {
    int effected = await _database.delete(
      'content',
      where: 'id = ?',
      whereArgs: [contentId]
    );
    return effected > 0;
  }

}