
import 'package:notes/data/services/interfaces/model/content/content_dto.dart';

abstract class LocalContentService {

  Future<List<ContentDto>> getContents(String noteId);
  Future<ContentDto?> getContentById(String noteId, String contentId);
  Future<ContentDto?> updateContent(String noteId, String contentId, ContentDto contentDto);
  Future<int> getContentsCount(String noteId);
  Future<void> switchPositions(String noteId, String firstContentId, String secondContentId);
}