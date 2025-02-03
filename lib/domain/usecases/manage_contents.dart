
import 'package:notes/data/dao/content_dao.dart';
import 'package:notes/data/dao/note_dao.dart';
import 'package:notes/domain/entities/content.dart';

class ManageContents {

  ManageContents._init();

  static final ManageContents _instance = ManageContents._init();

  static get instance => _instance;

  final ContentDao _contentDao = ContentDao.instance;
  final NoteDao _noteDao = NoteDao.instance;

  Future<Content?> createContent(String noteId, Content content, {int? index}) async {
    final int count = await _noteDao.contentsCount(noteId);
    content.position = count;
    if (index != null && index <= count) content.position = index;
    return await _contentDao.insertContent(noteId, content);
  }

  Future<bool> deleteContent(Content content) async {
    return await _contentDao.deleteContent(content);
  }

  Future<Content?> editContent(String contentId, Content content) async {
    return await _contentDao.updateContent(contentId, content);
  }
}