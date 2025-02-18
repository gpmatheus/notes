
import 'package:notes/domain/model/content/content.dart';

abstract class ContentTypeRepositoryInterface {

  Future<bool> deleteContent(String contentId);
  Future<Content?> getContent(String contentId);
  Future<List<Content>> getContents(String noteId);
  Future<bool> deleteTypedContent(String contentId);
}