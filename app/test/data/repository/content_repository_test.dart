
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
// ignore: unused_import
import 'package:mockito/mockito.dart';
import 'package:notes/data/repository/implementations/content_repository.dart';
import 'package:notes/data/repository/interfaces/content_repository_interface.dart';
import 'package:notes/data/services/interfaces/content_service.dart';

import 'content_repository_test.mocks.dart';

@GenerateMocks([ContentService])
void main() {

  // ignore: unused_local_variable
  late ContentRepositoryInterface repository;
  late MockLocalContentService contentService;

  group('Test ContentRepository implements ContentRepositoryInterface', () {

    setUp(() {
      contentService = MockLocalContentService();
      repository = ContentRepository(contentService: contentService);
    });

    // test('Test switchPositions', () async {
    //   const String noteId = 'noteId';
    //   final Content first = TextContent(id: 'first', createdAt: DateTime.now(), lastEdited: DateTime.now(), position: 0, text: 'first');
    //   final Content second = ImageContent(id: 'second', createdAt: DateTime.now(), lastEdited: DateTime.now(), position: 1, imageFileName: '123456.png', file: null);
    //   final ContentDto firstDto = ContentDto(id: first.id, createdAt: first.createdAt, lastEdited: first.lastEdited, position: second.position, noteId: noteId);
    //   final ContentDto secondDto = ContentDto(id: second.id, createdAt: second.createdAt, lastEdited: second.lastEdited, position: first.position, noteId: noteId);

    //   when(contentService.updateContent(first.id, firstDto)).thenAnswer((_) async => firstDto);
    //   when(contentService.updateContent(second.id, secondDto)).thenAnswer((_) async => secondDto);

    //   final bool result = await repository.switchPositions(noteId, first, second);

    //   expect(result, true);
    //   verify(contentService.updateContent('first', firstDto)).called(1);
    //   verify(contentService.updateContent('second', secondDto)).called(1);
    // });
  });
}