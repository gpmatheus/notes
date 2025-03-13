import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes/data/services/local/config/sqlite_database.dart';
import 'package:notes/data/services/local/local_content_database_sqlite_service.dart';
import 'package:notes/data/services/interfaces/local_content_service.dart';
import 'package:notes/data/services/interfaces/model/content/content_dto.dart';

void main() {
  late LocalContentService service;
  late SqliteDatabase database;

  group('Test LocalContentDatabaseSqliteService implements LocalContentService', () {
    group('test the getContents method', () {

      setUp(() async {
        database = SqliteDatabase.forTesting(NativeDatabase.memory());
        service = LocalContentDatabaseSqliteService(database: database);

        await database.into(database.noteLocalModel).insert(
          NoteLocalModelCompanion.insert(
            id: const Value('noteId'),
            name: 'note 1',
            createdAt: Value(DateTime.now()),
            lastEdited: const Value(null),
          ),
        );

        await database.into(database.contentLocalModel).insert(
          ContentLocalModelCompanion.insert(
            id: const Value('12345'),
            createdAt: Value(DateTime.now()),
            lastEdited: const Value(null),
            noteId: 'noteId',
            position: 0,
          ),
        );

        await database.into(database.contentLocalModel).insert(
          ContentLocalModelCompanion.insert(
            id: const Value('67890'),
            createdAt: Value(DateTime.now()),
            lastEdited: const Value(null),
            noteId: 'noteId',
            position: 1,
          ),
        );
      });

      tearDown(() async {
        await database.close();
      });

      test('should return a list of ContentDto of length 2', () async {
        final contents = await service.getContents('noteId'); 
        expect(contents.length, 2);
      });

      test('should return a list of ContentDto of length 0', () async {
        final contents = await service.getContents(''); 
        expect(contents.length, 0);
      });

    });

    group('test the getContentById method', () {

      setUp(() async {
        database = SqliteDatabase.forTesting(NativeDatabase.memory());
        service = LocalContentDatabaseSqliteService(database: database);

        await database.into(database.noteLocalModel).insert(
          NoteLocalModelCompanion.insert(
            id: const Value('noteId'),
            name: 'note 1',
            createdAt: Value(DateTime.now()),
            lastEdited: const Value(null),
          ),
        );

        await database.into(database.contentLocalModel).insert(
          ContentLocalModelCompanion.insert(
            id: const Value('12345'),
            createdAt: Value(DateTime.now()),
            lastEdited: const Value(null),
            noteId: 'noteId',
            position: 0,
          ),
        );

        await database.into(database.contentLocalModel).insert(
          ContentLocalModelCompanion.insert(
            id: const Value('67890'),
            createdAt: Value(DateTime.now()),
            lastEdited: const Value(null),
            noteId: 'noteId',
            position: 1,
          ),
        );
      });

      tearDown(() async {
        await database.close();
      });

      test('should return a ContentDto then valid id is provided', () async {
        final content = await service.getContentById('12345'); 
        expect(content, isNotNull);
        expect(content!.id, '12345');
      });

      test('should throw an exception when invalid id is provided', () async {
        callMethod() async => await service.getContentById(''); 
        expect(callMethod, throwsA(isA<Exception>()));
      });

    });

    group('test the updateContent method', () {

      setUp(() async {
        database = SqliteDatabase.forTesting(NativeDatabase.memory());
        service = LocalContentDatabaseSqliteService(database: database);

        await database.into(database.noteLocalModel).insert(
          NoteLocalModelCompanion.insert(
            id: const Value('noteId'),
            name: 'note 1',
            createdAt: Value(DateTime.now()),
            lastEdited: const Value(null),
          ),
        );

        await database.into(database.contentLocalModel).insert(
          ContentLocalModelCompanion.insert(
            id: const Value('12345'),
            createdAt: Value(DateTime.now()),
            lastEdited: const Value(null),
            noteId: 'noteId',
            position: 0,
          ),
        );

        await database.into(database.contentLocalModel).insert(
          ContentLocalModelCompanion.insert(
            id: const Value('67890'),
            createdAt: Value(DateTime.now()),
            lastEdited: const Value(null),
            noteId: 'noteId',
            position: 1,
          ),
        );
      });

      tearDown(() async {
        await database.close();
      });

      test('should return a ContentDto when valid information is provided', () async {
        final content = await service.updateContent('12345', ContentDto(
          id: '',
          noteId: 'noteId',
          position: 0,
          createdAt: DateTime.now(),
          lastEdited: DateTime.now(),
        )); 
        expect(content, isNotNull);
        expect(content!.id, '12345');
      });

      test('should throw an exception when trying to change noteId', () async {
        callMethod() async => await service.updateContent('12345', ContentDto(
          id: '12345',
          noteId: 'noteId2',
          position: 0,
          createdAt: DateTime.now(),
          lastEdited: DateTime.now(),
        )); 
        expect(callMethod, throwsA(isA<Exception>()));
      });

      test('should throw an exception when an invalid id is provided', () async {
        callMethod() async => await service.updateContent('', ContentDto(
          id: '12345',
          noteId: 'noteId',
          position: 0,
          createdAt: DateTime.now(),
          lastEdited: null,
        )); 
        expect(callMethod, throwsA(isA<Exception>()));
      });

    });

  });
  
}