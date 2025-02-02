
import 'package:notes/data/dao/content_dao.dart';
import 'package:notes/data/datasources/interfaces.dart';
import 'package:notes/data/datasources/note_data_resource.dart';
import 'package:notes/domain/entities/content.dart';
import 'package:notes/domain/entities/note.dart';

class NoteDao {

  NoteDao._init();

  static final NoteDao _instance = NoteDao._init();

  static get instance {
    return _instance;
  }

  final NoteDataSource _dataSource = NoteLocalDataSourceImpl();
  final Map<String, Note> _notes = {};

  Future<Note> insertNote(Note note) async {
    Note insertedNote = await _dataSource.createNote(note);
    _notes[note.id] = note;
    return insertedNote;
  }

  Future<Note?> updateNote(String noteId, Note note) async {
    Note? updatedNote = await _dataSource.updateNote(noteId, note);
    if (updatedNote != null) _notes[noteId] = updatedNote;
    return updatedNote;
  }

  Future<bool> deleteNote(String noteId) async {
    bool deleted = await _dataSource.deleteNote(noteId);
    _notes.remove(noteId);
    return deleted;
  }

  Future<Note?> getNote(String noteId) async {
    Note? note = _notes[noteId];
    note ??= await _dataSource.getNote(noteId);
    if (note != null) {
      _notes[noteId] = note;
      ContentDao contentDao = ContentDao.instance;
      List<Content> contents = await contentDao.getContents(noteId);
      note.contents = contents;
    }
    return note;
  }

  Future<List<Note>> getNotes() async {
    List<Note> notes = await _dataSource.getNotes();
    for (Note n in notes) {
      _notes[n.id] = n;
    }
    return notes;
  }

  Future<List<int>?> changeContentsOrder(String noteId, List<int> positions) async {
    return _dataSource.changeContentsOrder(noteId, positions);
  }

  Future<int> getContentsCount(String noteId) {
    return _dataSource.getContentsCount(noteId);
  }
}