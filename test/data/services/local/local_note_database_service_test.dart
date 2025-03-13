
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes/data/services/local/implementations/config/sqlite_database.dart';
import 'package:notes/data/services/local/implementations/local_note_database_sqlite_service.dart';
import 'package:notes/data/services/local/interfaces/local_note_service.dart';
import 'package:notes/data/services/local/interfaces/model/note/note_dto.dart';

void main() {

  late LocalNoteService service;
  late SqliteDatabase database;

  group('Test LocalDatabaseSqliteService implements LocalNoteService', () {
    group('test the getNoteById method', () {
      
      setUp(() async {
        database = SqliteDatabase.forTesting(NativeDatabase.memory());
        service = LocalNoteDatabaseSqliteService(database: database);

        await database.into(database.noteLocalModel).insert(
          NoteLocalModelCompanion.insert(
            id: const drift.Value('12345'),
            name: 'name',
            createdAt: drift.Value(DateTime.now()),
            lastEdited: drift.Value(DateTime.now()),
          ),
        );

        await database.into(database.noteLocalModel).insert(
          NoteLocalModelCompanion.insert(
            id: const drift.Value('67890'),
            name: 'name',
            createdAt: drift.Value(DateTime.now()),
            lastEdited: const drift.Value(null),
          ),
        );
      });

      tearDown(() async {
        await database.close();
      });

      test('should return a NoteDto when proper information is provided', () async {
        final note = await service.getNoteById('12345');
        expect(note, isNotNull);
        expect(note!.id, '12345');
        expect(note.createdAt, isNotNull);
        expect(note.lastEdited, isNotNull);
      });

      test('should return a null when invalid id is provided', () async {
        callMethod() async => await service.getNoteById('');
        expect(callMethod, throwsA(isA<Exception>()));
      });
    });

    group('test the getNotes method', () {
      
      setUp(() async {
        database = SqliteDatabase.forTesting(NativeDatabase.memory());
        service = LocalNoteDatabaseSqliteService(database: database);

        await database.into(database.noteLocalModel).insert(
          NoteLocalModelCompanion.insert(
            id: const drift.Value('12345'),
            name: 'name',
            createdAt: drift.Value(DateTime.now()),
            lastEdited: drift.Value(DateTime.now()),
          ),
        );

        await database.into(database.noteLocalModel).insert(
          NoteLocalModelCompanion.insert(
            id: const drift.Value('67890'),
            name: 'name',
            createdAt: drift.Value(DateTime.now()),
            lastEdited: drift.Value(DateTime.now()),
          ),
        );
      });

      tearDown(() async {
        await database.close();
      });

      test('should return a list of NoteDto of length 2', () async {
        final notes = await service.getNotes();
        expect(notes.length, 2);
      });
    });

    group('test the createNote method 1', () {
      
      setUp(() async {
        database = SqliteDatabase.forTesting(NativeDatabase.memory());
        service = LocalNoteDatabaseSqliteService(database: database);
      });

      tearDown(() async {
        await database.close();
      });

      test('should return a NoteDto when proper information is provided', () async {

        final DateTime createdAt = DateTime.now();
        final note = await service.createNote(NoteDto(
          id: '12345',
          name: 'name',
          createdAt: createdAt,
          lastEdited: null,
        ));
        expect(note, isNotNull);
        expect(note!.id, '12345');
        expect(note.createdAt, isNotNull);
        expect(note.lastEdited, null);
      });

      test('should throw exception when invalid id is provided', () async {
        callMethod() async => await service.createNote(NoteDto(
          id: '',
          name: 'name',
          createdAt: DateTime.now(),
          lastEdited: null,
        ));
        expect(callMethod, throwsA(isA<Exception>()));
      });

      group('test the createNote method 2', () {

        setUp(() async {
          await database.into(database.noteLocalModel).insert(
            NoteLocalModelCompanion.insert(
              id: const drift.Value('00000'),
              name: 'name',
              createdAt: drift.Value(DateTime.now()),
              lastEdited: drift.Value(DateTime.now()),
            ),
          );
        });

        tearDown(() async {
          await database.close();
        });

        test('equal ids should throw an exception when providing non unique id', () async {
          methodCall() async => await service.createNote(NoteDto(
            id: '00000',
            name: 'name',
            createdAt: DateTime.now(),
            lastEdited: DateTime.now(),
          ));
          expect(methodCall, throwsA(isA<Exception>()));
        });

      });

    });


    group('test the updateNote method', () {
      
      setUp(() async {
        database = SqliteDatabase.forTesting(NativeDatabase.memory());
        service = LocalNoteDatabaseSqliteService(database: database);

        await database.into(database.noteLocalModel).insert(
          NoteLocalModelCompanion.insert(
            id: const drift.Value('12345'),
            name: 'name',
            createdAt: drift.Value(DateTime.now()),
            lastEdited: drift.Value(DateTime.now()),
          ),
        );

        await database.into(database.noteLocalModel).insert(
          NoteLocalModelCompanion.insert(
            id: const drift.Value('67890'),
            name: 'name',
            createdAt: drift.Value(DateTime.now()),
            lastEdited: drift.Value(DateTime.now()),
          ),
        );
      });

      tearDown(() async {
        await database.close();
      });

      test('should return a NoteDto when proper information is provided', () async {
        final note = await service.updateNote('12345', NoteDto(
          id: '12345',
          name: 'name',
          createdAt: DateTime.now(),
          lastEdited: DateTime.now(),
        )); 
        expect(note!.id, '12345');
        expect(note.name, 'name');
        expect(note.createdAt, isNotNull);
        expect(note.lastEdited, isNotNull);
      });

      test('should throw an exception when invalid id is provided', () async {
        callMethod() async => await service.updateNote('', NoteDto(
          id: '12345',
          name: 'name',
          createdAt: DateTime.now(),
          lastEdited: null,
        )); 
        expect(callMethod, throwsA(isA<Exception>()));
      });
    });

    group('test the deleteNote method', () {
      
      setUp(() async {
        database = SqliteDatabase.forTesting(NativeDatabase.memory());
        service = LocalNoteDatabaseSqliteService(database: database);

        await database.into(database.noteLocalModel).insert(
          NoteLocalModelCompanion.insert(
            id: const drift.Value('12345'),
            name: 'name',
            createdAt: drift.Value(DateTime.now()),
            lastEdited: drift.Value(DateTime.now()),
          ),
        );

        await database.into(database.noteLocalModel).insert(
          NoteLocalModelCompanion.insert(
            id: const drift.Value('67890'),
            name: 'name',
            createdAt: drift.Value(DateTime.now()),
            lastEdited: drift.Value(DateTime.now()),
          ),
        );
      });

      tearDown(() async {
        await database.close();
      });

      // TODO
      // test('should return true then valid id is provided', () async {
      //   final result = await service.deleteNote('12345');
      //   expect(result, true);
      // });

      // test('should return false when invalid id is provided', () async {
      //   final result = await service.deleteNote('');
      //   expect(result, false);
      // });
    });
  });
}