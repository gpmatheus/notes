
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes/data/services/local/config/sqlite_database.dart';
import 'package:notes/data/services/local/local_textcontent_database_sqlite_service.dart';
import 'package:notes/data/services/interfaces/local_text_content_service.dart';
import 'package:notes/data/services/interfaces/model/content/types/text/textcontent_dto.dart';

void main() {

  late SqliteDatabase database;
  late LocalTextContentService service;

  group('Test LocalTextcontentDatabaseSqliteService implements LocalTextContentService', () {
    group('test the createTextContent method', () {

      setUp(() async {
        database = SqliteDatabase.forTesting(NativeDatabase.memory());
        service = LocalTextcontentDatabaseSqliteService(database: database);

        await database.into(database.noteLocalModel).insert(
          NoteLocalModelCompanion.insert(
            id: const drift.Value('noteId'),
            name: 'note 1',
            createdAt: drift.Value(DateTime.now()),
            lastEdited: const drift.Value(null),
          ),
        );
      });

      tearDown(() async {
        await database.close();
      });

      test('should return a TextContentDto when proper information is provided', () async {
        final textContent = await service.createTextContent(
          TextcontentDto(
            id: '12345', 
            createdAt: DateTime.now(), 
            lastEdited: null, 
            position: 0, 
            text: 'qualquer texto mesmo!', 
            noteId: 'noteId',
          )
        );
        expect(textContent, isNotNull);
      });

      test('should return a null when invalid noteId is provided', () async {
        final textContent = await service.createTextContent(
          TextcontentDto(
            id: '56789', 
            createdAt: DateTime.now(), 
            lastEdited: null, 
            position: 0, 
            text: 'qualquer texto mesmo!', 
            noteId: '',
          )
        );
        expect(textContent, null);
      });
    });

    group('test the updateTextContent method', () {
      
      setUp(() async {
        database = SqliteDatabase.forTesting(NativeDatabase.memory());
        service = LocalTextcontentDatabaseSqliteService(database: database);

        await database.into(database.noteLocalModel).insert(
          NoteLocalModelCompanion.insert(
            id: const drift.Value('noteId'),
            name: 'note 1',
            createdAt: drift.Value(DateTime.now()),
            lastEdited: const drift.Value(null),
          ),
        );

        await database.into(database.contentLocalModel).insert(
          ContentLocalModelCompanion.insert(
            id: const drift.Value('12345'),
            createdAt: drift.Value(DateTime.now()),
            lastEdited: const drift.Value(null),
            noteId: 'noteId',
            position: 0,
          ),
        );

        await database.into(database.textContentLocalModel).insert(
          TextContentLocalModelCompanion.insert(
            contentId: '12345',
            textContent: 'qualquer texto mesmo!',
          ),
        );
      });

      tearDown(() async {
        await database.close();
      });

      test('should return a TextContentDto when proper information is provided', () async {
        final textContent = await service.updateTextContent(
          '12345',
          TextcontentDto(
            id: '12345', 
            createdAt: DateTime.now(), 
            lastEdited: null, 
            position: 0, 
            text: 'qualquer texto mesmo!', 
            noteId: 'noteId',
          ),
        );
        expect(textContent, isNotNull);
      });

      test('should return a TextContentDt when a different id is provided in TextcontentDto', () async {
        final textContent = await service.updateTextContent(
          '12345',
          TextcontentDto(
            id: '00000', 
            createdAt: DateTime.now(), 
            lastEdited: null, 
            position: 0, 
            text: 'qualquer texto mesmo!', 
            noteId: 'noteId',
          ),
        );
        expect(textContent, isNotNull);
      });

      test('should throw an exception when trying to change noteId', () async {
        callMethod() async => await service.updateTextContent(
          '12345',
          TextcontentDto(
            id: '56789', 
            createdAt: DateTime.now(), 
            lastEdited: null, 
            position: 0, 
            text: 'qualquer texto mesmo!', 
            noteId: '',
          )
        );
        expect(callMethod, throwsA(isA<Exception>()));
      });
    });
  });
}