
import 'package:drift/drift.dart';
import 'package:notes/data/services/local/model/note_local_model.dart';
import 'package:uuid/uuid.dart';

@DataClassName('ContentDrift')
class ContentLocalModel extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  DateTimeColumn get createdAt => 
    dateTime().withDefault(Constant(DateTime.now())).named('created_at')();
  DateTimeColumn get lastEdited => dateTime().nullable().named('last_edited')();
  IntColumn get position => integer()();

  TextColumn get noteId => text().references(NoteLocalModel, #id, onDelete: KeyAction.cascade)();
}