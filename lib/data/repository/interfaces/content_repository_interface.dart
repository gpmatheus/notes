
import 'package:notes/domain/model/content/content.dart';

abstract class ContentRepositoryInterface {

  Future<bool> deleteContent(String contentId);
  Future<bool> switchPositions(String noteId, Content first, Content second);
}