
import 'dart:io';

import 'package:notes/config/configurations/sqlite_config.dart';
import 'package:notes/domain/entities/content.dart';
import 'package:notes/domain/entities/note.dart';
import 'package:sqflite/sqflite.dart';

abstract class NoteDataSource {

  final Database _database = SqliteHelper.instance.database!;

  Future<Note> createNote(Note note);
  Future<Note?> getNote(String noteId);
  Future<List<Note>> getNotes();
  Future<Note?> updateNote(String noteId, Note note);
  Future<bool> deleteNote(String noteId);
  Future<bool> switchPosition(String noteId, int oldIndex, int newIndex);
  Future<int> getContentsCount(String noteId) async {
    var result = await _database.rawQuery(
      """
        SELECT COUNT(*) FROM content
        WHERE content.note_id = '$noteId';
      """
    );
    int? count = Sqflite.firstIntValue(result);
    return count ?? 0;
  }
}

abstract class ContentDataSource {

  Future<Content?> createContent(String noteId, Content content);
  Future<List<Content>> getContents(String noteId);
  Future<Content?> updateContent(String contentId, Content content);
  Future<bool> deleteContent(String contentId);
}

abstract class ImageFileDataSource {

  Future<String> saveImage(File image);
  Future<bool> deleteImage(String path);
  Future<String?> substituteImage(String previousPath, String newPath);
  Future<File?> getImage(String path);
}
