
import 'package:notes/domain/contents/content_types.dart';
import 'package:notes/domain/entities/content.dart';

class ContentDao {

  ContentDao._init();

  static final ContentDao _instance = ContentDao._init();

  static get instance => _instance;

  final Map<String, Content> _contents = {};

  Future<Content?> insertContent(String noteId, Content content) async {
    final dataSource = content.contentsType().localDataResource;
    Content? insertContent = await dataSource.createContent(noteId, content);
    if (insertContent != null) _contents[content.id] = content;
    return insertContent;
  }

  Future<Content?> updateContent(String contentId, Content content) async {
    final dataSource = content.contentsType().localDataResource;
    Content? updatedContent = await dataSource.updateContent(contentId, content);
    if (updatedContent != null) _contents[contentId] = updatedContent;
    return updatedContent;
  }

  Future<bool> deleteContent(Content content) async {
    final dataSource = content.contentsType().localDataResource;
    bool deleted = await dataSource.deleteContent(content.id);
    _contents.remove(content.id);
    return deleted;
  }

  Future<List<Content>> getContents(String noteId) async {
    final List<Content> contents = [];
    for (ContentsType type in ContentsType.all) {
      contents.addAll(await type.localDataResource.getContents(noteId));
    }
    contents.sort((Content first, Content second) {
      return first.createdAt.compareTo(second.createdAt);
    });
    return contents;
  }

}