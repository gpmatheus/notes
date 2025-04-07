
import 'package:logger/logger.dart';
import 'package:notes/data/repository/interfaces/content_repository_interface.dart';
import 'package:notes/data/services/interfaces/content_service.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/utils/formatted_logger.dart';

class ContentRepository implements ContentRepositoryInterface {

  ContentRepository({
    required ContentService contentService,
  }) : _contentService = contentService;


  final ContentService _contentService;
  final Logger _logger = FormattedLogger.instance;

  @override
  Future<bool> switchPositions(String noteId, Content first, Content second) async {
    try {
      await _contentService.switchPositions(noteId, first.id, second.id);
      return true;
    } on Exception catch (e) {
      _logger.e(e.toString());
      return false;
    }
  }

}