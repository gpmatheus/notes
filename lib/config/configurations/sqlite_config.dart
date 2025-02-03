
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/config/init.dart';
import 'package:notes/domain/entities/content.dart';
import 'package:notes/domain/entities/note.dart';
import 'package:notes/domain/usecases/maintain_notes.dart';
import 'package:notes/domain/usecases/manage_contents.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteConfig implements AppConfig {

  @override
  Future<void> execute() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = await openDatabase(
      join(await getDatabasesPath(), 'note_database.db'),
      onCreate: (db, version) {
        return _setup(db);
      },
      version: 1,
    );
    SqliteHelper.instance.setDatabase(database);
  }

  Future<void> _setup(Database database) async {
    SqliteHelper.instance.setDatabase(database);
    await _dropTables(database);
    await _createTables(database);
    await _populate(database);
  }

  Future<void> _dropTables(Database database) async {

    const String dropNote = """
      DROP TABLE IF EXISTS note;
    """;
    await database.execute(dropNote);

    const String dropContent = """
      DROP TABLE IF EXISTS content;
    """;
    await database.execute(dropContent);

    const String dropTextContent = """
      DROP TABLE IF EXISTS text_content;
    """;
    await database.execute(dropTextContent);

    const String dropImageContent = """
      DROP TABLE IF EXISTS image_content;
    """;
    await database.execute(dropImageContent);

    const String dropDrawingContent = """
      DROP TABLE IF EXISTS drawing_content;
    """;
    await database.execute(dropDrawingContent);
  }
  
  Future<void> _createTables(Database database) async {

    // cria a tabela de nota
    const String createNote = """
      CREATE TABLE note (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        last_edited TEXT
      );
    """;
    await database.execute(createNote);

    // cria a tabela de conteúdo
    const String createContent = """
      CREATE TABLE content (
        id TEXT PRIMARY KEY,
        created_at TEXT NOT NULL,
        last_edited TEXT,
        note_id TEXT NOT NULL,
        position INTEGER NOT NULL,
        FOREIGN KEY(note_id) REFERENCES note(id)
      );
    """;
    await database.execute(createContent);

    const String createTextContent = """
      CREATE TABLE text_content (
        content_id TEXT PRIMARY KEY,
        text TEXT NOT NULL,
        FOREIGN KEY(content_id) REFERENCES content(id) ON DELETE CASCADE
      );
    """;
    await database.execute(createTextContent);

    const String createImageContent = """
      CREATE TABLE image_content (
        content_id TEXT PRIMARY KEY,
        image_file_name TEXT,
        FOREIGN KEY(content_id) REFERENCES content(id) ON DELETE CASCADE
      );
    """;
    await database.execute(createImageContent);

    const String createDrawingContent = """
      CREATE TABLE drawing_content (
        content_id TEXT PRIMARY KEY,
        drawing TEXT,
        FOREIGN KEY(content_id) REFERENCES content(id) ON DELETE CASCADE
      );
    """;
    await database.execute(createDrawingContent);
  }

  Future<void> _populate(Database database) async {

    MaintainNotes maintainNotes = MaintainNotes.instance;
    Note note = (await maintainNotes.createNote('primeira anotação'))!;

    ManageContents manageContents = ManageContents.instance;
    Content content1 = (await manageContents.createContent(note.id, TextContent(text: 'boramano')))!;

    XFile? xfile = (await ImagePicker().pickImage(source: ImageSource.gallery));
    File? file;
    if (xfile != null) file = File(xfile.path);
    if (file != null) {
      print('Caminho do arquivo: $file');
      ImageContent? content2 = (await manageContents.createContent(note.id, ImageContent(file: file))) as ImageContent?;
      if (content2 != null) {
        print('Caminho da image é ${content2.imageFileName}');
      }
    } else {
      print('Nenhum arquivo foi selecionado.');
    }

    // Map<String, dynamic> data = jsonDecode("""
    //   {
    //       "lines": [
    //           {
    //               "points": [
    //                   {
    //                       "x": -0.5,
    //                       "y": -0.5
    //                   },
    //                   {
    //                       "x": -0.5,
    //                       "y": 0.5
    //                   },
    //                   {
    //                       "x": 0.5,
    //                       "y": -0.5
    //                   },
    //                   {
    //                       "x": 0.5,
    //                       "y": 0.6
    //                   }
    //               ],
    //               "color": 0,
    //               "strokeWidth": 0.4
    //           }
    //       ]
    //   }""");
    // DrawingContent? content3 = (await manageContents.createContent(note.id, DrawingContent(data))) as DrawingContent?;
  }

}

class SqliteHelper {

  SqliteHelper._init();

  static final SqliteHelper instance = SqliteHelper._init();

  static Database? _database;

  bool setDatabase(Database database) {
    if (_database != null) return false;
    _database = database;
    return true;
  }

  Database? get database {
    return _database;
  }
}