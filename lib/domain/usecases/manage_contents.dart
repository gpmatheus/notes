
import 'package:notes/data/repository/interfaces/content_repository_interface.dart';
import 'package:notes/data/repository/interfaces/utils/content_type_repository_interface.dart';
import 'package:notes/domain/model/content/content.dart';

class ManageContents {
  
  ManageContents({
    required ContentRepositoryInterface contentRepository,
    required  List<ContentTypeRepositoryInterface> contentTypeRepositories,
  }) : 
    _contentRepository = contentRepository,
    _contentTypeRepositories = contentTypeRepositories;

  final ContentRepositoryInterface _contentRepository;
  final List<ContentTypeRepositoryInterface> _contentTypeRepositories;

  Future<bool> deleteContent(String contentId) async {
    return _contentTypeRepositories.isEmpty ? false : _delete(0, contentId);
  }

  Future<bool> _delete(int index, String contentId) async {
    if (index >= _contentTypeRepositories.length) return false;
    try {
      await _contentTypeRepositories[index].deleteTypedContent(contentId);
      return true;
    } on Exception catch (_) {
      return await _delete(index + 1, contentId);
    }
  }

  Future<List<Content>> getContents(String noteId) async {
    final List<Content> contents = [];
    for (var rep in _contentTypeRepositories) {
      contents.addAll(await rep.getContents(noteId));
    }
    contents.sort((first, second) => first.position.compareTo(second.position));
    return contents;
  }

  Future<List<Content>?> switchPositions(String noteId, Content first, Content second) async {
    final bool success = await _contentRepository.switchPositions(noteId, first, second);
    return success ? getContents(noteId) : null;
  }
}