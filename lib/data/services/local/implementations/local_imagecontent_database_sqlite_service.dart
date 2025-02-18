
import 'package:drift/drift.dart';
import 'package:notes/data/services/local/implementations/utils/local_content_database.dart';
import 'package:notes/data/services/local/implementations/config/sqlite_database.dart';
import 'package:notes/data/services/local/interfaces/local_image_content_service.dart';
import 'package:notes/data/services/local/interfaces/model/content/content_dto.dart';
import 'package:notes/data/services/local/interfaces/model/content/types/image/imagecontent_dto.dart';

class LocalImagecontentDatabaseSqliteService extends
    LocalContentDatabase<ImageContentLocalModelCompanion, ImageContentDrift, ImagecontentDto> implements
    LocalImageContentService {
  
  LocalImagecontentDatabaseSqliteService({
    required super.database
  }) : super(resImpl: database.imageContentLocalModel);
  
  @override
  ImageContentLocalModelCompanion? convertToCompanion(ImagecontentDto content) {
    return ImageContentLocalModelCompanion(
      contentId: Value(content.id),
      imageFileName: Value(content.imageFileName),
    );
  }

  @override
  ImagecontentDto? convertToDto(ContentDto? contentDto, ImageContentDrift? content) {
    return content == null || contentDto == null
    ? null 
    : ImagecontentDto(
        id: contentDto.id,
        createdAt: contentDto.createdAt,
        lastEdited: contentDto.lastEdited,
        position: contentDto.position,
        imageFileName: content.imageFileName,
        noteId: contentDto.noteId,
    );
  }
  
  @override
  String getId(ImageContentDrift content) {
    return content.contentId;
  }
  
  @override
  Future<ImagecontentDto?> createImageContent(ImagecontentDto content) {
    return super.createTypedContent(content);
  }
  
  @override
  Future<ContentDto?> getContnetById(String id) {
    return super.getContentById(id);
  }
  
  @override
  Future<ImagecontentDto?> updateImageContent(String contentId, ImagecontentDto content) {
    return super.updateTypedContent(contentId, content);
  }
}