
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/user/user.dart';

abstract class ContentTypeRepositoryInterface {

  Future<Content> getContent(String noteId, String contentId, User? user);
  Future<List<Content>> getContents(String noteId, User? user);
  Future<void> deleteTypedContent(String noteId, String contentId, User? user);
}