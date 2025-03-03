
import 'package:notes/data/repository/interfaces/text_content_repository_interface.dart';
import 'package:notes/data/services/local/interfaces/local_text_content_service.dart';
import 'package:notes/data/services/local/interfaces/model/content/content_dto.dart';
import 'package:notes/data/services/local/interfaces/model/content/types/text/textcontent_dto.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/content/text_content/text_content.dart';
import 'package:uuid/uuid.dart';

class TextContentRepository implements TextContentRepositoryInterface {

  TextContentRepository({
    required LocalTextContentService localTextContentService,
  }): 
    _localTextContentService = localTextContentService;

  final LocalTextContentService _localTextContentService;

  @override
  Future<Content?> createContent({
    required String noteId, 
    required String text,
    required int position}) async {
    if (position < 0) return null;
    final TextcontentDto? result = await _localTextContentService.createTextContent(
      TextcontentDto(
        id: const Uuid().v4(), 
        createdAt: DateTime.now(), 
        lastEdited: null, 
        position: position, 
        text: text, 
        noteId: noteId
      )
    );
    if (result == null) return null;
    return _fromDto(result);
  }

  @override
  Future<bool> deleteContent(String contentId) async {
    return await _localTextContentService.deleteTypedContent(contentId);
  }

  @override
  Future<Content?> getContent(String contentId) async {
    final TextcontentDto? result = await 
      _localTextContentService.getContentById(contentId) as TextcontentDto?;
    if (result == null) return null;
    return _fromDto(result);
  }

  @override
  Future<List<Content>> getContents(String noteId) async {
    final List<ContentDto> result = await _localTextContentService.getContents(noteId);
    return [
      for (var res in result)
        _fromDto(res as TextcontentDto)!
    ];
  }

  @override
  Future<Content?> updateContent({
    required String contentId,
    required String noteId, 
    required String text,
    required int position}) async {

    final TextcontentDto? contentDto = await 
      _localTextContentService.getContentById(contentId) as TextcontentDto?;
    if (contentDto == null) return null;
    
    final TextcontentDto? updatedContent = await _localTextContentService.updateTextContent(
      contentId, 
      TextcontentDto(
        id: contentDto.id, 
        createdAt: contentDto.createdAt, 
        lastEdited: DateTime.now(), 
        position: position, 
        text: text, 
        noteId: noteId
      ),
    );
    if (updatedContent == null) return null;
    return _fromDto(updatedContent);
  }

  TextContent? _fromDto(TextcontentDto content) {
    return TextContent(
      id: content.id, 
      createdAt: content.createdAt, 
      lastEdited: content.lastEdited, 
      position: content.position, 
      text: content.text
    );
  }
  
  @override
  Future<bool> deleteTypedContent(String contentId) async {
    return await _localTextContentService.deleteTypedContent(contentId);
  }

}