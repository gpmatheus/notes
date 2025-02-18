
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

@DataClassName('NoteDrift')
class NoteLocalModel extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => 
    dateTime().withDefault(Constant(DateTime.now())).named('created_at')();
  DateTimeColumn get lastEdited => dateTime().nullable().named('last_edited')();

  @override
  Set<Column> get primaryKey => {id};
}