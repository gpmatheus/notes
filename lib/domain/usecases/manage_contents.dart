
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
    for (var rep in _contentTypeRepositories) {
      await rep.deleteTypedContent(contentId);
    }
    return false;
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