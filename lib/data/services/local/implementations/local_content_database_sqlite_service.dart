
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:notes/data/services/local/implementations/config/sqlite_database.dart';
import 'package:notes/data/services/local/interfaces/local_content_service.dart';
import 'package:notes/data/services/local/interfaces/model/content/content_dto.dart';

class LocalContentDatabaseSqliteService implements LocalContentService {
  LocalContentDatabaseSqliteService({
    required this.database,
  });

  @protected
  SqliteDatabase database;

  @override
  @protected
  Future<ContentDto?> getContentById(String id) async {
    var result = await (database.select(database.contentLocalModel)
        ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    return _convertToDto(result);
  }

  @override
  @protected
  Future<List<ContentDto>> getContents(String noteId) async {
    var result = await (database.select(database.contentLocalModel)
        ..where((table) => table.noteId.equals(noteId)))
        .get();
    return [
      for (var res in result)
        _convertToDto(res)!
    ];
  }

  @protected
  Future<ContentDto?> createContent(ContentDto contentDto) async {
    ContentLocalModelCompanion? model = _convertToCompanion(contentDto, null);
    if (model == null) return null;
    var result = await database.into(database.contentLocalModel).insertReturningOrNull(model);
    return _convertToDto(result);
  }
  
  @override
  @protected
  Future<ContentDto?> updateContent(String id, ContentDto contentDto) async {
    final bool noteExists = await (database.select(database.noteLocalModel)
        ..where((table) => table.id.equals(contentDto.noteId)))
        .getSingleOrNull() != null;
    if (!noteExists) return null;
    ContentLocalModelCompanion? model = _convertToCompanion(contentDto, id);
    if (model == null) return null;
    List<ContentDrift> result = await (database.update(database.contentLocalModel)
        ..where((table) => table.id.equals(id)))
        .writeReturning(model);
    ContentDrift? updated = result.isNotEmpty ? result.first : null;
    return _convertToDto(updated);
  }

  @protected
  Future<bool> deleteContent(String contentId) async {
    return (await (database.delete(database.contentLocalModel)
        ..where((table) => table.id.equals(contentId))).go()) > 0;
  }

  ContentLocalModelCompanion? _convertToCompanion(ContentDto content, String? id) {
    return ContentLocalModelCompanion(
      id: id != null ? Value(id) : Value(content.id),
      createdAt: Value(content.createdAt),
      lastEdited: Value(content.lastEdited),
      position: Value(content.position),
      noteId: Value(content.noteId),
    );
  }

  ContentDto? _convertToDto(ContentDrift? content) {
    return content == null 
    ? null 
    : ContentDto(
      id: content.id,
      createdAt: content.createdAt,
      lastEdited: content.lastEdited,
      position: content.position,
      noteId: content.noteId,
    );
  }
}