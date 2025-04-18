
import 'package:logger/logger.dart';
import 'package:notes/data/repository/interfaces/text_content_repository_interface.dart';
import 'package:notes/data/services/interfaces/content_service.dart';
import 'package:notes/data/services/interfaces/text_content_service.dart';
import 'package:notes/data/services/interfaces/model/content/content_dto.dart';
import 'package:notes/data/services/interfaces/model/content/types/text/textcontent_dto.dart';
import 'package:notes/data/services/interfaces/model/exceptions/invalid_input_exception.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/content/text_content/text_content.dart';
import 'package:notes/utils/formatted_logger.dart';
import 'package:uuid/uuid.dart';

class TextContentRepository implements TextContentRepositoryInterface {

  TextContentRepository({
    required TextContentService localTextContentService,
    required ContentService localContentService,
  }): 
    _localTextContentService = localTextContentService,
    _localContentService = localContentService;

  final TextContentService _localTextContentService;
  final ContentService _localContentService;
  final Logger _logger = FormattedLogger.instance;

  @override
  Future<Content?> createContent({
    required String noteId, 
    required String text,
    required int? position}) async {
    
    position = await _localContentService.getContentsCount(noteId);
    try {
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
    } on InvalidInputException {
      rethrow;
    } on Exception catch (e) {
      _logger.e('Error creating content: $e');
      return null;
    }
  }

  @override
  Future<Content?> getContent(String noteId, String contentId) async {
    try {
      final TextcontentDto? result = await 
        _localTextContentService.getContentById(noteId, contentId) as TextcontentDto?;
      if (result == null) return null;
      return _fromDto(result);
    } on InvalidInputException {
      rethrow;
    } on Exception catch (e) {
      _logger.e('Error getting content: $e');
      return null;
    }
  }

  @override
  Future<List<Content>> getContents(String noteId) async {
    try {
      final List<ContentDto> result = await _localTextContentService.getContents(noteId);
      return [
        for (var res in result)
          _fromDto(res as TextcontentDto)!
      ];
    } on InvalidInputException {
      rethrow;
    } on Exception catch (e) {
      _logger.e('Error getting contents: $e');
      return [];
    }
  }

  @override
  Future<Content?> updateContent({
    required String contentId,
    required String noteId, 
    required String text
    }) async {

    final TextcontentDto? contentDto = await 
      _localTextContentService.getContentById(noteId, contentId) as TextcontentDto?;
    if (contentDto == null) return null;
    
    try {
      final TextcontentDto? updatedContent = await _localTextContentService.updateTextContent(
        contentId, 
        TextcontentDto(
          id: contentDto.id, 
          createdAt: contentDto.createdAt, 
          lastEdited: DateTime.now(), 
          position: contentDto.position, 
          text: text, 
          noteId: noteId
        ),
      );
      if (updatedContent == null) return null;
      return _fromDto(updatedContent);
    } on InvalidInputException {
      rethrow;
    } on Exception catch (e) {
      _logger.e('Error updating content: $e');
      return null;
    }
  }

  @override
  Future<void> deleteTypedContent(String noteId, String contentId) {
    return _localTextContentService.deleteTypedContent(noteId, contentId);
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

}