
import 'package:notes/data/repository/interfaces/utils/content_type_repository_interface.dart';
import 'package:notes/domain/model/content/content.dart';

abstract class TextContentRepositoryInterface extends ContentTypeRepositoryInterface {

  Future<Content?> createContent({
    required String noteId, 
    required String text,
    required int position,
  });
  Future<Content?> updateContent({
    required String contentId, 
    required String noteId,
    required String text,
    required int position,
  });
}