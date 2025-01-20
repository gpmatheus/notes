
import 'package:notes/data/dao/content_dao.dart';
import 'package:notes/domain/entities/content.dart';

class ManageContents {

  ManageContents._init();

  static final ManageContents _instance = ManageContents._init();

  static get instance {
    return _instance;
  }

  final ContentDao _contentDao = ContentDao.instance;

  Future<Content?> createContent(String noteId, Content content) async {
    return await _contentDao.insertContent(noteId, content);
  }

  Future<bool> deleteContent(Content content) async {
    return await _contentDao.deleteContent(content);
  }

  Future<Content?> editContent(String contentId, Content content) async {
    return await _contentDao.updateContent(contentId, content);
  }
}