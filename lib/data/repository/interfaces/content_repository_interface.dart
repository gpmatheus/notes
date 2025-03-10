
import 'package:notes/domain/model/content/content.dart';

abstract class ContentRepositoryInterface {

  Future<bool> switchPositions(String noteId, Content first, Content second);
}