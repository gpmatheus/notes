
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
      _userRepository.authStateChanges.listen((user) {
        _user = user;
      });
    }

  // ignore: unused_field
  final UserRepositoryInterface _userRepository;
  final NoteRepositoryInterface _noteRepository;
  final ManageContents _manageContents;

  User? _user;

  Future<List<Note>> getAllNotes() async {
    return await _noteRepository.getNotes(_user);
  }

  Future<Note?> getNote(String noteId) async {
    Note note;
    try {
      note = await _noteRepository.getNote(noteId, _user);
    } on Exception {
      return null;
    }
    List<Content> contents = await _manageContents.getContents(noteId);
    if (note.contents != null) note.contents!.addAll(contents);
    return note;
  }

  Future<Note?> createNote(String name) async {
    return _noteRepository.insertNote(name, _user);
  }

  Future<Note?> updateNote(String noteId, String name) async {
    return _noteRepository.updateNote(noteId, name, _user);
  }

  Future<bool> deleteNote(String noteId) async {
    return _noteRepository.deleteNote(noteId, _user);
  }

}