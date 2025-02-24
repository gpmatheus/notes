
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
// import 'package:drift/native.dart';
import 'package:notes/data/services/local/implementations/model/note_local_model.dart';
import 'package:path_provider/path_provider.dart';

import 'package:notes/data/services/local/implementations/model/content_local_model.dart';
import 'package:notes/data/services/local/implementations/model/drawing_content_local_model.dart';
import 'package:notes/data/services/local/implementations/model/image_content_local_model.dart';
import 'package:notes/data/services/local/implementations/model/text_content_local_model.dart';
import 'package:uuid/uuid.dart';

part 'sqlite_database.g.dart';

@DriftDatabase(tables: [
  NoteLocalModel,
  ContentLocalModel, 
  TextContentLocalModel, 
  ImageContentLocalModel, 
  DrawingContentLocalModel
])
class SqliteDatabase extends _$SqliteDatabase {

  SqliteDatabase(): super(_openConnection());

  SqliteDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  // static LazyDatabase _openConnection() {
  //   return LazyDatabase(() async {
  //     final appDocumentsDir = await getApplicationDocumentsDirectory();
  //     final dbDirectory = Directory(p.join(appDocumentsDir.parent.path, 'databases'));
  //     if (!await dbDirectory.exists()) {
  //       await dbDirectory.create(recursive: true);
  //     }
  //     return NativeDatabase.createInBackground(File(p.join(dbDirectory.path, 'app_database.sqlite')));
  //   });
  // }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: DriftNativeOptions(
        databaseDirectory: () async {
          final appDocumentsDir = await getApplicationDocumentsDirectory();
          final dbDirectory = Directory(p.join(appDocumentsDir.parent.path, 'databases'));
          if (!await dbDirectory.exists()) {
            await dbDirectory.create(recursive: true);
          }
          return dbDirectory;
        },
        
      ),
    );
  }
}
