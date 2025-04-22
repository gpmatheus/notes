
import 'package:notes/data/repository/interfaces/note_repository_interface.dart';
import 'package:notes/data/repository/interfaces/user_repository_interface.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/note/note.dart';
import 'package:notes/domain/model/user/user.dart';
import 'package:notes/domain/usecases/manage_contents.dart';

class MaintainNotes {

  MaintainNotes({
    required UserRepositoryInterface userRepository,
    required NoteRepositoryInterface noteRepository,
    required ManageContents manageContents,
  }) : 
    _userRepository = userRepository,
    _noteRepository = noteRepository,
    _manageContents = manageContents {
      _futureUser = userRepository.currentUser;
    }

  // ignore: unused_field
  final UserRepositoryInterface _userRepository;
  final NoteRepositoryInterface _noteRepository;
  final ManageContents _manageContents;

  late final Future<User?> _futureUser;

  Future<List<Note>> getAllNotes() async {
    final user = await _futureUser;
    return await _noteRepository.getNotes(user);
  }

  Future<Note?> getNote(String noteId) async {
    final user = await _futureUser;
    Note note;
    try {
      note = await _noteRepository.getNote(noteId, user);
    } on Exception {
      return null;
    }
    List<Content> contents = await _manageContents.getContents(noteId);
    if (note.contents != null) note.contents!.addAll(contents);
    return note;
  }

  Future<Note?> createNote(String name) async {
    final user = await _futureUser;
    return _noteRepository.insertNote(name, user);
  }

  Future<Note?> updateNote(String noteId, String name) async {
    final user = await _futureUser;
    return _noteRepository.updateNote(noteId, name, user);
  }

  Future<bool> deleteNote(String noteId) async {
    final user = await _futureUser;
    return _noteRepository.deleteNote(noteId, user);
  }

}