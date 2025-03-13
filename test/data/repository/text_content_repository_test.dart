
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
// ignore: unused_import
import 'package:mockito/mockito.dart';
import 'package:notes/data/repository/implementations/text_content_repository.dart';
import 'package:notes/data/repository/interfaces/text_content_repository_interface.dart';
import 'package:notes/data/services/local/interfaces/local_text_content_service.dart';

import 'content_repository_test.mocks.dart';
import 'text_content_repository_test.mocks.dart';

@GenerateMocks([LocalTextContentService])
void main() {

  // ignore: unused_local_variable
  late TextContentRepositoryInterface repository;
  late MockLocalTextContentService service;
  late MockLocalContentService contentService;
  
  group('Test TextContentRepository implements TextContentRepositoryInterface', () {

    group('test the createContent method', () {

      setUp(() {
        service = MockLocalTextContentService();
        contentService = MockLocalContentService();
        repository = TextContentRepository(
          localTextContentService: service, 
          localContentService: contentService,
        );
      });

      // test('should return a TextContent when valid information is provided', () async {
      //   // arrange
      //   const noteId = 'noteId';
      //   const text = 'text';
      //   const position = 0;
      //   final contentDto = TextcontentDto(
      //     id: 'id',
      //     createdAt: DateTime.now(),
      //     lastEdited: null,
      //     position: position,
      //     text: text,
      //     noteId: noteId,
      //   );
      //   when(service.createTextContent(any)).thenAnswer((_) async => contentDto);
      //   // act
      //   TextContent? result = await repository.createContent(
      //     noteId: noteId,
      //     text: text,
      //     position: position,
      //   ) as TextContent?;
      //   // assert
      //   expect(result, isNotNull);
      //   expect(result!.id, 'id');
      //   verify(service.createTextContent(any));
      // });

      // test('should return null when the service returns null', () async {
      //   // arrange
      //   const noteId = 'noteId';
      //   const text = 'text';
      //   const position = 0;
      //   when(service.createTextContent(any)).thenAnswer((_) async => null);
      //   // act
      //   TextContent? result = await repository.createContent(
      //     noteId: noteId,
      //     text: text,
      //     position: position,
      //   ) as TextContent?;
      //   // assert
      //   expect(result, isNull);
      //   verify(service.createTextContent(any));
      // });

      // test('should return null when inserting negative position', () async {
      //   // arrange
      //   const noteId = 'noteId';
      //   const text = 'text';
      //   const position = -1;
      //   // act

      //   TextContent? result = await repository.createContent(
      //     noteId: noteId,
      //     text: text,
      //     position: position,
      //   ) as TextContent?;

      //   // assert
      //   expect(result, null);
      // });
    });
  });
}