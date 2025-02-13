
import 'package:notes/data/dao/note_dao.dart';
import 'package:notes/domain/entities/note.dart';

class MaintainNotes {

  MaintainNotes._init();

  static final MaintainNotes _instance = MaintainNotes._init();

  static get instance {
    return _instance;
  }

  final NoteDao noteDao = NoteDao.instance;

  Future<List<Note>> getAllNotes() async {
    return await noteDao.getNotes();
  }

  Future<Note?> getNote(String noteId) async {
    return await noteDao.getNote(noteId);
  }

  Future<Note?> createNote(String name) async {
    Note note = Note(name: name);
    return noteDao.insertNote(note);
  }

  Future<bool> switchPositions(String noteId, int oldIndex, int newIndex) async {
    return noteDao.switchPositions(noteId, oldIndex, newIndex);
  }

}