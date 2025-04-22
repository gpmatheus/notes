
import 'package:notes/data/repository/interfaces/utils/content_type_repository_interface.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/user/user.dart';

abstract class TextContentRepositoryInterface extends ContentTypeRepositoryInterface {

  Future<Content> createContent(
    String noteId, 
    String text,
    int? position,
    User? user,
  );
  Future<Content> updateContent(
    String contentId, 
    String noteId,
    String text,
    User? user
  );
}