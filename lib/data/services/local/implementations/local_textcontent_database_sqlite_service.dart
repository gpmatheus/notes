
import 'package:drift/drift.dart';
import 'package:notes/data/services/local/implementations/utils/local_content_database.dart';
import 'package:notes/data/services/local/implementations/config/sqlite_database.dart';
import 'package:notes/data/services/local/interfaces/local_text_content_service.dart';
import 'package:notes/data/services/local/interfaces/model/content/content_dto.dart';
import 'package:notes/data/services/local/interfaces/model/content/types/text/textcontent_dto.dart';

class LocalTextcontentDatabaseSqliteService extends 
  LocalContentDatabase<TextContentLocalModelCompanion, TextContentDrift, TextcontentDto> implements 
  LocalTextContentService {

  LocalTextcontentDatabaseSqliteService({
    required super.database
  }) : super(resImpl:  database.textContentLocalModel);
  
  @override
  TextContentLocalModelCompanion? convertToCompanion(TextcontentDto content) {
    return TextContentLocalModelCompanion(
      contentId: Value(content.id),
      textContent: Value(content.text),
    );
  }
  
  @override
  TextcontentDto? convertToDto(ContentDto? contentDto, TextContentDrift? content) {
    return content == null || contentDto == null
    ? null 
    : TextcontentDto(
        id: contentDto.id,
        createdAt: contentDto.createdAt,
        lastEdited: contentDto.lastEdited,
        position: contentDto.position,
        text: content.textContent, 
        noteId: contentDto.noteId,
    );
  }
  
  @override
  String getId(TextContentDrift content) {
    return content.contentId;
  }
  
  @override
  Future<ContentDto?> getContnetById(String id) {
    return super.getContentById(id);
  }
  
  @override
  Future<TextcontentDto?> createTextContent(TextcontentDto content) {
    return super.createTypedContent(content);
  }
  
  @override
  Future<TextcontentDto?> updateTextContent(String contentId, TextcontentDto content) {
    return super.updateTypedContent(contentId, content);
  }

}