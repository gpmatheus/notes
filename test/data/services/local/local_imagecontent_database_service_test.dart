
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes/data/services/local/implementations/config/sqlite_database.dart';
import 'package:notes/data/services/local/implementations/local_imagecontent_database_sqlite_service.dart';
import 'package:notes/data/services/local/interfaces/local_image_content_service.dart';
import 'package:notes/data/services/local/interfaces/model/content/types/image/imagecontent_dto.dart';

void main() {

  late SqliteDatabase database;
  late LocalImageContentService service;

  group('Test LocalImagecontentDatabaseSqliteService implements LocalImageContentService', () {
    group('test the createImageContent method', () {
      
      setUp(() async {
        database = SqliteDatabase.forTesting(NativeDatabase.memory());
        service = LocalImagecontentDatabaseSqliteService(database: database);

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

      test('should return a ImageContentDto when proper information is provided', () async {
        final imageContent = await service.createImageContent(
          ImagecontentDto(
            id: '12345', 
            createdAt: DateTime.now(), 
            lastEdited: null, 
            position: 0,
            imageFileName: '12354758395793.png',
            noteId: 'noteId',
          )
        );
        expect(imageContent, isNotNull);
      });

      test('should return a null when providing a invalid noteId', () async {
        final imageContent = await service.createImageContent(
          ImagecontentDto(
            id: '56789', 
            createdAt: DateTime.now(), 
            lastEdited: null, 
            position: 0,
            imageFileName: '12354758395793.png',
            noteId: '',
          )
        );
        expect(imageContent, null);
      });

      test('should return a null when providing an empty imageFileName', () async {
        final imageContent = await service.createImageContent(
          ImagecontentDto(
            id: '56789', 
            createdAt: DateTime.now(), 
            lastEdited: null, 
            position: 0,
            imageFileName: '',
            noteId: 'noteId',
          )
        );
        expect(imageContent, null);
      });
    });

    group('teste the updateImageContent method', () {
      
      setUp(() async {
        database = SqliteDatabase.forTesting(NativeDatabase.memory());
        service = LocalImagecontentDatabaseSqliteService(database: database);

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

        await database.into(database.imageContentLocalModel).insert(
          ImageContentLocalModelCompanion.insert(
            contentId: '12345',
            imageFileName: 'qualquer texto mesmo!',
          ),
        );

      });

      tearDown(() async {
        await database.close();
      });

      test('should return a ImageContentDto when providing proper information', () async {
        final imageContent = await service.updateImageContent(
          '12345',
          ImagecontentDto(
            id: 'imageId', 
            createdAt: DateTime.now(), 
            lastEdited: null, 
            position: 0,
            imageFileName: '12354758395793.png',
            noteId: 'noteId',
          )
        );
        expect(imageContent, isNotNull);
      });

      test('should return a null when providing invalid noteId', () async {
        final imageContent = await service.updateImageContent(
          '12345',
          ImagecontentDto(
            id: 'imageId', 
            createdAt: DateTime.now(), 
            lastEdited: null, 
            position: 0,
            imageFileName: '12354758395793.png',
            noteId: '',
          )
        );
        expect(imageContent, null);
      });

      test('should return a null when providing empty imageFileName', () async {
        final imageContent = await service.updateImageContent(
          '12345',
          ImagecontentDto(
            id: 'imageId', 
            createdAt: DateTime.now(), 
            lastEdited: null, 
            position: 0,
            imageFileName: '',
            noteId: 'noteId',
          )
        );
        expect(imageContent, null);
      });

      test('should return a null when providing invalid id', () async {
        final imageContent = await service.updateImageContent(
          '1234567',
          ImagecontentDto(
            id: 'imageId', 
            createdAt: DateTime.now(), 
            lastEdited: null, 
            position: 0,
            imageFileName: '12354758395793.png',
            noteId: 'noteId',
          )
        );
        expect(imageContent, null);
      });
    });
  });
}