
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:notes/data/services/local/implementations/local_content_database_sqlite_service.dart';
import 'package:notes/data/services/local/implementations/model/utils/contents_model.dart';
import 'package:notes/data/services/local/interfaces/model/content/content_dto.dart';
import 'package:notes/data/services/local/interfaces/model/exceptions/not_found_exception.dart';

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
    if (result == null) throw NotFoundException('Content not found');
    
    return convertToDto(contentResult, result);
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
    if (!(await _noteExists(contentDto.noteId))) return null;
    C? result = await database.transaction(() async {
      ContentDto? createdContent = await super.createContent(contentDto as ContentDto);

      T? model = convertToCompanion(contentDto);
      if (model == null) throw Exception('Something went wrong');
      R? createdTextContent = await database
        .into(resImpl).insertReturningOrNull(model as Insertable<R>) as R;
      if (createdTextContent == null) throw Exception('Something went wrong');
      return convertToDto(createdContent, createdTextContent);
    });
    return result;
  }

  @protected
  Future<C?> updateTypedContent(String contentId, C contentDto) async {
    if (!(await _noteExists(contentDto.noteId))) throw NotFoundException('Note not found');
    C? result = await database.transaction(() async {
      ContentDto? updatedContent = await super.updateContent(
        contentId, 
        contentDto as ContentDto,
      );

      T? model = convertToCompanion(contentDto);
      if (model == null) throw Exception('Something went wrong');
      List<R> updatedResult = await (database
        .update(resImpl)
        ..where((table) => (table as ContentsModel).contentId.equals(contentId)))
        .writeReturning(model as Insertable<R>);
      R? updated = updatedResult.isNotEmpty ? updatedResult.first : null;
      if (updated == null) throw Exception('Something went wrong');
      return convertToDto(updatedContent, updated);
    });
    return result;
  }

  @protected
  Future<void> deleteTypedContent(String contentId) async {
    await database.transaction(() async {
      final bool success = await (database.delete(resImpl)
        ..where((table) => (table as ContentsModel).contentId.equals(contentId)))
        .go() > 0;
      if (!success) throw Exception('Something went wrong');
      await super.deleteContent(contentId);
    });
  }

  @protected
  T? convertToCompanion(C content);

  @protected
  C? convertToDto(ContentDto? contentDto, R? content);

  @protected
  String getId(R content);

  Future<bool> _noteExists(String noteId) async {
    return await (database.select(database.noteLocalModel)
      ..where((table) => table.id.equals(noteId)))
      .get()
      .then((value) => value.isNotEmpty);
  }
}