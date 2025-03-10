
import 'package:notes/data/services/local/interfaces/model/content/content_dto.dart';

abstract class LocalContentService {

  Future<List<ContentDto>> getContents(String noteId);
  Future<ContentDto?> getContentById(String contentId);
  Future<ContentDto?> updateContent(String contentId, ContentDto contentDto);
  Future<int> getContentsCount(String noteId);
  Future<void> switchPositions(String firstContentId, String secondContentId);
}