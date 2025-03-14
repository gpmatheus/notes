
import 'package:notes/domain/model/content/content.dart';

abstract class ContentTypeRepositoryInterface {

  Future<Content?> getContent(String noteId, String contentId);
  Future<List<Content>> getContents(String noteId);
  Future<void> deleteTypedContent(String noteId, String contentId);
}