
import 'package:notes/config/configurations/sqlite_config.dart';
import 'package:notes/data/datasources/interfaces.dart';
import 'package:notes/domain/entities/content.dart';
import 'package:sqflite/sqflite.dart';

class TextContentDataResource extends ContentDataSource {

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

    content as TextContent;
    await _database.insert(
      'text_content',
      content.toChildMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return content;
  }

  @override
  Future<List<Content>> getContents(String noteId) async {
    const String query = """
        SELECT 
        child.text AS content_field, 
        child.content_id AS id, 
        con.created_at AS created_at, 
        con.last_edited AS last_edited
        FROM text_content AS child
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
        'content_field': text as String,
      } in results)
      TextContent.existing(
        id: id, 
        createdAt: DateTime.tryParse(createdAt), 
        lastEdited: lastEdited != null ? DateTime.tryParse(lastEdited) : null, 
        text: text
      )
    ];
  }

  @override
  Future<Content?> updateContent(String contentId, Content content) async {
    content as TextContent;
    TextContent? resultContent;
    final DateTime lastEdited = DateTime.now();
    int effected = await _database.update(
      'text_content',
      {
        'text': content.text,
      },
      where: 'content_id = ?',
      whereArgs: [contentId]
    );
    if (effected > 0) {
      await _database.update(
        'content',
        {
          'last_edited': lastEdited.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [contentId]
      );
    }

    List<Map<String, Object?>> conRes = await _database.query(
      'content',
      where: 'id = ?',
      whereArgs: [contentId]
    );
    if (conRes.isEmpty) throw Exception('No content');
    final resConMap = conRes.first;
    resultContent = TextContent.existing(
      id: contentId, 
      createdAt: DateTime.tryParse(resConMap['created_at'] as String), 
      lastEdited: lastEdited, 
      text: content.text,
    );

    return effected > 0 
    ? resultContent 
    : null;
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
