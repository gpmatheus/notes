
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/user/user.dart';

abstract class ContentRepositoryInterface {

  Future<bool> switchPositions(String noteId, Content first, Content second, User? user);
}