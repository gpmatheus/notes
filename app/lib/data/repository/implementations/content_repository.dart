
import 'package:notes/data/repository/interfaces/content_repository_interface.dart';
import 'package:notes/data/services/interfaces/content_service.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/user/user.dart';

class ContentRepository implements ContentRepositoryInterface {

  ContentRepository({
    required ContentService contentService,
    required ContentService remoteContentService,
  }) : 
    _contentService = contentService,
    _remoteContentService = remoteContentService;


  final ContentService _contentService;
  final ContentService _remoteContentService;

  @override
  Future<bool> switchPositions(String noteId, Content first, Content second, User? user) async {
    try {
      await _contentService.switchPositions(noteId, first.id, second.id);
      if (user != null && user.remoteSave) {
        await _remoteContentService.switchPositions(noteId, first.id, second.id);
      }
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

}