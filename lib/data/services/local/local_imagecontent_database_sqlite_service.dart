
import 'package:drift/drift.dart';
import 'package:notes/data/services/local/utils/local_content_database.dart';
import 'package:notes/data/services/local/config/sqlite_database.dart';
import 'package:notes/data/services/interfaces/local_image_content_service.dart';
import 'package:notes/data/services/interfaces/model/content/content_dto.dart';
import 'package:notes/data/services/interfaces/model/content/types/image/imagecontent_dto.dart';
import 'package:notes/data/services/interfaces/model/exceptions/invalid_file_exception.dart';

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
    if (_emptyImageFileName(content)) throw InvalidFileException('Image file name cannot be empty');
    return super.createTypedContent(content);
  }
  
  @override
  Future<ImagecontentDto?> updateImageContent(String contentId, ImagecontentDto content) {
    if (_emptyImageFileName(content)) throw InvalidFileException('Image file name cannot be empty');
    return super.updateTypedContent(contentId, content);
  }

  bool _emptyImageFileName(ImagecontentDto content) {
    return content.imageFileName.trim().isEmpty;
  }
}