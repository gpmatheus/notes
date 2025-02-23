
import 'package:notes/data/repository/interfaces/content_repository_interface.dart';
import 'package:notes/data/services/local/interfaces/local_content_service.dart';
import 'package:notes/data/services/local/interfaces/model/content/content_dto.dart';
import 'package:notes/domain/model/content/content.dart';

class ContentRepository implements ContentRepositoryInterface {

  ContentRepository({
    required LocalContentService contentService,
  }) : _contentService = contentService;


  final LocalContentService _contentService;

  // @override
  // Future<bool> deleteContent(String contentId) async {
  //   return await _contentService.deleteContent(contentId);
  // }

  @override
  Future<bool> switchPositions(String noteId, Content first, Content second) async {
    final int firstPosition = first.position;
    final int secondPosition = second.position;

    final ContentDto firstDto = ContentDto(
      id: first.id, 
      createdAt: first.createdAt, 
      lastEdited: first.lastEdited, 
      position: secondPosition, 
      noteId: noteId,
    );

    final ContentDto secondDto = ContentDto(
      id: second.id, 
      createdAt: second.createdAt, 
      lastEdited: second.lastEdited, 
      position: firstPosition, 
      noteId: noteId,
    );

    final bool firstSuccess = await _contentService.updateContent(first.id, firstDto) != null;
    if (!firstSuccess) return false;
    final bool secondSuccess = await _contentService.updateContent(second.id, secondDto) != null;
    return secondSuccess;
  }

}