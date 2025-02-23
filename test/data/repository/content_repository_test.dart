
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:notes/data/repository/implementations/content_repository.dart';
import 'package:notes/data/repository/interfaces/content_repository_interface.dart';
import 'package:notes/data/services/local/interfaces/local_content_service.dart';
import 'package:notes/data/services/local/interfaces/model/content/content_dto.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/content/image_content/image_content.dart';
import 'package:notes/domain/model/content/text_content/text_content.dart';

import 'content_repository_test.mocks.dart';

@GenerateMocks([LocalContentService])
void main() {

  late ContentRepositoryInterface repository;
  late MockLocalContentService contentService;

  group('Test ContentRepository implements ContentRepositoryInterface', () {

    setUp(() {
      contentService = MockLocalContentService();
      repository = ContentRepository(contentService: contentService);
    });

    test('Test switchPositions', () async {
      const String noteId = 'noteId';
      final Content first = TextContent(id: 'first', createdAt: DateTime.now(), lastEdited: DateTime.now(), position: 0, text: 'first');
      final Content second = ImageContent(id: 'second', createdAt: DateTime.now(), lastEdited: DateTime.now(), position: 1, imageFileName: '123456.png', file: null);
      final ContentDto firstDto = ContentDto(id: first.id, createdAt: first.createdAt, lastEdited: first.lastEdited, position: second.position, noteId: noteId);
      final ContentDto secondDto = ContentDto(id: second.id, createdAt: second.createdAt, lastEdited: second.lastEdited, position: first.position, noteId: noteId);

      when(contentService.updateContent('first', any)).thenAnswer((_) async => firstDto);
      when(contentService.updateContent('second', any)).thenAnswer((_) async => secondDto);

      final bool result = await repository.switchPositions(noteId, first, second);

      expect(result, true);
      verify(contentService.updateContent('first', any));
      verify(contentService.updateContent('second', any));
    });
  });
}