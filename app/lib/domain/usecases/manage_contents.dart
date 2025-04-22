
import 'package:notes/data/repository/interfaces/content_repository_interface.dart';
import 'package:notes/data/repository/interfaces/user_repository_interface.dart';
import 'package:notes/data/repository/interfaces/utils/content_type_repository_interface.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/user/user.dart';

class ManageContents {
  
  ManageContents({
    required UserRepositoryInterface userRepository,
    required ContentRepositoryInterface contentRepository,
    required List<ContentTypeRepositoryInterface> contentTypeRepositories,
  }) : 
    _userRepository = userRepository,
    _contentRepository = contentRepository,
    _contentTypeRepositories = contentTypeRepositories {
      _futureUser = userRepository.currentUser;
    }

  // ignore: unused_field
  final UserRepositoryInterface _userRepository;
  final ContentRepositoryInterface _contentRepository;
  final List<ContentTypeRepositoryInterface> _contentTypeRepositories;

  late final Future<User?> _futureUser;

  Future<bool> deleteContent(String noteId, String contentId) async {
    return _contentTypeRepositories.isEmpty ? false : _delete(0, noteId, contentId);
  }

  Future<bool> _delete(int index, String noteId, String contentId) async {
    final user = await _futureUser;
    if (index >= _contentTypeRepositories.length) return false;
    try {
      await _contentTypeRepositories[index].deleteTypedContent(noteId, contentId, user);
      return true;
    } on Exception catch (_) {
      return await _delete(index + 1, noteId, contentId);
    }
  }

  Future<List<Content>> getContents(String noteId) async {
    final user = await _futureUser;
    final List<Content> contents = [];
    for (var rep in _contentTypeRepositories) {
      contents.addAll(await rep.getContents(noteId, user));
    }
    contents.sort((first, second) => first.position.compareTo(second.position));
    return contents;
  }

  Future<List<Content>?> switchPositions(String noteId, Content first, Content second) async {
    final user = await _futureUser;
    final bool success = await _contentRepository.switchPositions(noteId, first, second, user);
    return success ? getContents(noteId) : null;
  }
}