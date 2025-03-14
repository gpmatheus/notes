
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:notes/data/services/local/config/sqlite_database.dart';
import 'package:notes/data/services/interfaces/local_content_service.dart';
import 'package:notes/data/services/interfaces/model/content/content_dto.dart';
import 'package:notes/data/services/interfaces/model/exceptions/not_found_exception.dart';

class LocalContentDatabaseSqliteService implements LocalContentService {
  LocalContentDatabaseSqliteService({
    required this.database,
  });

  @protected
  SqliteDatabase database;

  @override
  @protected
  Future<ContentDto?> getContentById(String noteId, String id) async {
    var result = await (database.select(database.contentLocalModel)
        ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    if (result == null) throw NotFoundException('Content not found');
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
        _convertToDto(res)
    ];
  }

  @protected
  Future<ContentDto?> createContent(ContentDto contentDto) async {
    ContentLocalModelCompanion model = _convertToCompanion(contentDto, null);
    var result = await database.into(database.contentLocalModel).insertReturningOrNull(model);
    if (result == null) throw Exception('Something went wrong');
    return _convertToDto(result);
  }
  
  @override
  @protected
  Future<ContentDto?> updateContent(String noteId, String id, ContentDto contentDto) async {
    final bool noteExists = await (database.select(database.noteLocalModel)
        ..where((table) => table.id.equals(contentDto.noteId)))
        .getSingleOrNull() != null;
    if (!noteExists) throw NotFoundException('Note not found');
    ContentLocalModelCompanion model = _convertToCompanion(contentDto, id);
    List<ContentDrift> result = await (database.update(database.contentLocalModel)
        ..where((table) => table.id.equals(id)))
        .writeReturning(model);
    if (result.isEmpty) throw NotFoundException('Content not found');
    final ContentDrift updated = result.first;
    return _convertToDto(updated);
  }

  @protected
  Future<void> deleteContent(String contentId) async {
    final ContentDrift? content = await (database.select(database.contentLocalModel)
        ..where((table) => table.id.equals(contentId)))
        .getSingleOrNull();
    if (content == null) throw NotFoundException('Content not found');
    final String noteId = content.noteId;
    final bool success = (await (database.delete(database.contentLocalModel)
        ..where((table) => table.id.equals(contentId))).go()) > 0;
    if (!success) throw Exception('Something went wrong');
    await _restorePositions(noteId);
  }

  Future<void> _restorePositions(String noteId) async {
    List<ContentDto> contents = await getContents(noteId);
    contents.sort((a, b) => a.position.compareTo(b.position));
    database.transaction(() async {
      for (int i = 0; i < contents.length; i++) {
        await updateContent(noteId, contents[i].id, ContentDto(
          id: contents[i].id,
          createdAt: contents[i].createdAt,
          lastEdited: contents[i].lastEdited,
          position: i,
          noteId: contents[i].noteId,
        ));
      }
    });
  }

  @override
  Future<int> getContentsCount(String noteId) async {
    return (await getContents(noteId)).length;
  }
  
  @override
  Future<void> switchPositions(String noteId, String firstContentId, String secondContentId) async {
    ContentDto firstContent = (await getContentById(noteId, firstContentId))!;
    ContentDto secondContent = (await getContentById(noteId, secondContentId))!;

    await database.transaction(() async {
      ContentDto updatedFirstContent = ContentDto(
        id: firstContent.id, 
        createdAt: firstContent.createdAt, 
        lastEdited: firstContent.lastEdited, 
        position: secondContent.position, 
        noteId: firstContent.noteId,
      );

      ContentDto updatedSecondContent = ContentDto(
        id: secondContent.id, 
        createdAt: secondContent.createdAt, 
        lastEdited: secondContent.lastEdited, 
        position: firstContent.position, 
        noteId: secondContent.noteId,
      );

      await updateContent(noteId, firstContentId, updatedFirstContent);
      await updateContent(noteId, secondContentId, updatedSecondContent);
    });
  }

  ContentLocalModelCompanion _convertToCompanion(ContentDto content, String? id) {
    return ContentLocalModelCompanion(
      id: id != null ? Value(id) : Value(content.id),
      createdAt: Value(content.createdAt),
      lastEdited: Value(content.lastEdited),
      position: Value(content.position),
      noteId: Value(content.noteId),
    );
  }

  ContentDto _convertToDto(ContentDrift content) {
    return ContentDto(
      id: content.id,
      createdAt: content.createdAt,
      lastEdited: content.lastEdited,
      position: content.position,
      noteId: content.noteId,
    );
  }

}