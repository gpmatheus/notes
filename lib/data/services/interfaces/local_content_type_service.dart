
import 'package:notes/data/services/interfaces/model/content/content_dto.dart';

abstract class LocalContentTypeService {

  Future<ContentDto?> getContentById(String noteId, String id);
  Future<List<ContentDto>> getContents(String noteId);
  Future<void> deleteTypedContent(String noteId, String contentId);
}