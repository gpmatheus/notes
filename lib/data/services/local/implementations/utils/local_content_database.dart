
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:notes/data/services/local/implementations/local_content_database_sqlite_service.dart';
import 'package:notes/data/services/local/implementations/models/utils/contents_model.dart';
import 'package:notes/data/services/local/interfaces/model/content/content_dto.dart';

abstract class LocalContentDatabase<T, R, C extends ContentDto> extends LocalContentDatabaseSqliteService {

  LocalContentDatabase({
    required this.resImpl,
    required super.database,
  });

  final TableInfo<Table, R> resImpl;

  @override
  Future<ContentDto?> getContentById(String id) async {
    var contentResult = await super.getContentById(id);

    var result = await (database.select(resImpl)
        ..where((table) => (table as ContentsModel).contentId.equals(id)))
        .getSingleOrNull();
    
    return convertToDto(contentResult, result as R);
  }

  @override
  Future<List<ContentDto>> getContents(String noteId) async {
    var result = await super.getContents(noteId);
    List<ContentDto> contents = [];
    for (var res in result) {
      var content = await (database.select(resImpl)
        ..where((table) => (table as ContentsModel).contentId.equals(res.id)))
        .getSingleOrNull();
      C? contentDto = convertToDto(res, content);
      if (contentDto != null) contents.add(contentDto);
    }
    return contents;
  }

  @protected
  Future<C?> createTypedContent(C contentDto) async {
    C? result = await database.transaction(() async {
      ContentDto? createdContent = await super.createContent(contentDto as ContentDto);

      T? model = convertToCompanion(contentDto);
      if (model == null) return null;
      R? createdTextContent = await database
        .into(resImpl).insertReturningOrNull(model as Insertable<R>) as R;
      return convertToDto(createdContent, createdTextContent as R);
    });
    return result;
  }

  @protected
  Future<C?> updateTypedContent(String contentId, C contentDto) async {
    C? result = await database.transaction(() async {
      ContentDto? updatedContent = await super.updateContent(
        contentId, 
        contentDto as ContentDto,
      );

      T? model = convertToCompanion(contentDto);
      if (model == null) return null;
      List<R> updatedResult = await (database
        .update(resImpl)
        ..where((table) => (table as ContentsModel).contentId.equals(contentId)))
        .writeReturning(model as Insertable<R>);
      R? updated = updatedResult.isNotEmpty ? updatedResult.first : null;
      return convertToDto(updatedContent, updated as R);
    });
    return result;
  }

  @protected
  Future<bool> deleteTypedContent(String contentId) async {
    bool deleted = (await (database.delete(resImpl)
        ..where((table) => (table as ContentsModel).contentId.equals(contentId))).go()) > 0;
    if (deleted) deleted = await super.deleteContent(contentId);
    return deleted;
  }

  @protected
  T? convertToCompanion(C content);

  @protected
  C? convertToDto(ContentDto? contentDto, R? content);

  @protected
  String getId(R content);
}