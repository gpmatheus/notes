
import 'package:notes/config/configurations/sqlite_config.dart';
import 'package:notes/data/datasources/image_data_resource.dart';
import 'package:notes/data/datasources/interfaces.dart';
import 'package:notes/domain/entities/content.dart';
import 'package:sqflite/sqflite.dart';

class ImageContentDataResource extends ContentDataSource {

  final Database _database = SqliteHelper.instance.database!;
  final ImageFileDataSource imageRes = ImageFileDataSourceImpl();

  @override
  Future<Content?> createContent(String noteId, Content content) async {
    try {
      await _database.transaction((txn) async {
        await txn.insert(
          'content',
          {
            ...content.toParentMap(),
            'note_id': noteId,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        content as ImageContent;

        final String imageFileName = await imageRes.saveImage(content.file);
        content.imageFileName = imageFileName;
        content.file = (await imageRes.getImage(imageFileName))!;

        // salva os dados no banco de dados
        await txn.insert(
          'image_content',
          content.toChildMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
      return content;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Content>> getContents(String noteId) async {
    const String query = """
        SELECT 
        child.image_file_name AS content_field, 
        child.content_id AS id, 
        con.created_at AS created_at, 
        con.last_edited AS last_edited
        FROM image_content AS child
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
        'content_field': imageFileName as String,
      } in results)
      ImageContent.existing(
        id: id, 
        createdAt: DateTime.tryParse(createdAt), 
        lastEdited: lastEdited != null ? DateTime.tryParse(lastEdited) : null, 
        imageFileName: imageFileName,
        file: (await imageRes.getImage(imageFileName))!,
      )
    ];
  }

  @override
  Future<Content?> updateContent(String contentId, Content content) async {
    try {
      int effected = 0;
      content as ImageContent;
      await _database.transaction((txn) async {

        // atualiza o arquivo da imagem
        List<Map<String, Object?>> conRes = await txn.query(
          'image_content',
          where: 'content_id = ?',
          whereArgs: [contentId]
        );
        if (conRes.isEmpty) throw Exception('No content');
        final String imageFileName = conRes.first['image_file_name'] as String;
        final String? newImageFileName = await imageRes.substituteImage(imageFileName, content.file.path);
        if (newImageFileName == null) throw Exception('No content');

        // atualiza o banco de dados
        effected = await txn.update(
          'image_content',
          {
            'image_file_name': newImageFileName,
          },
          where: 'content_id = ?',
          whereArgs: [contentId]
        );
        if (effected > 0) {
          await txn.update(
            'content',
            {
              'last_edited': DateTime.now().toIso8601String(),
            },
            where: 'id = ?',
            whereArgs: [contentId]
          );
        }
      });
      return effected > 0 ? content : null;
    } catch (e) {
      return null;
    }
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