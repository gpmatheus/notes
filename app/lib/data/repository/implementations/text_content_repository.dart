
import 'package:notes/data/repository/interfaces/text_content_repository_interface.dart';
import 'package:notes/data/services/interfaces/content_service.dart';
import 'package:notes/data/services/interfaces/content_type_service.dart';
import 'package:notes/data/services/interfaces/text_content_service.dart';
import 'package:notes/data/services/interfaces/model/content/content_dto.dart';
import 'package:notes/data/services/interfaces/model/content/types/text/textcontent_dto.dart';
import 'package:notes/data/services/interfaces/model/exceptions/invalid_input_exception.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/content/text_content/text_content.dart';
import 'package:notes/domain/model/user/user.dart';
import 'package:uuid/uuid.dart';

class TextContentRepository implements TextContentRepositoryInterface {

  TextContentRepository({
    required TextContentService localTextContentService,
    required TextContentService remoteTextContentService,
    required ContentService localContentService,
    required ContentService remoteContentService,
  }): 
    _localTextContentService = localTextContentService,
    _remoteTextContentService = remoteTextContentService,
    _localContentService = localContentService,
    _remoteContentService = remoteContentService;

  final TextContentService _localTextContentService;
  final TextContentService _remoteTextContentService;
  final ContentService _localContentService;
  // ignore: unused_field
  final ContentService _remoteContentService;

  @override
  Future<Content> createContent(
    String noteId, 
    String text,
    int? position,
    User? user) async {
    
    position = await _localContentService.getContentsCount(noteId);
    final TextcontentDto newTextContent = TextcontentDto(
      id: const Uuid().v4(), 
      createdAt: DateTime.now(), 
      lastEdited: null, 
      position: position, 
      text: text, 
      noteId: noteId
    );

    try {
      final TextcontentDto result = await _localTextContentService.createTextContent(newTextContent);
      if (user != null && user.remoteSave) {
        await _remoteTextContentService.createTextContent(newTextContent);
      }
      return _fromDto(result);
    } on InvalidInputException {
      rethrow;
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<Content> getContent(String noteId, String contentId, User? user) async {
    try {
      final ContentTypeService service = (user == null || !user.remoteSave) 
        ? _localTextContentService 
        : _remoteTextContentService;
      final TextcontentDto result = await service.getContentById(noteId, contentId) as TextcontentDto;
      return _fromDto(result);
    } on InvalidInputException {
      rethrow;
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<Content>> getContents(String noteId, User? user) async {
    try {
      final ContentTypeService service = (user == null || !user.remoteSave) 
        ? _localTextContentService
        : _remoteTextContentService;
      final List<ContentDto> result = await service.getContents(noteId);
      return [
        for (var res in result)
          _fromDto(res as TextcontentDto)
      ];
    } on InvalidInputException {
      rethrow;
    } on Exception catch (_) {
      return [];
    }
  }

  @override
  Future<Content> updateContent(
    String contentId,
    String noteId, 
    String text,
    User? user) async {

    final TextcontentDto contentDto = await 
      _localTextContentService.getContentById(noteId, contentId) as TextcontentDto;
    
    try {
      final TextcontentDto updatedContent = await _localTextContentService.updateTextContent(
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
      return _fromDto(updatedContent);
    } on InvalidInputException {
      rethrow;
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTypedContent(String noteId, String contentId, User? user) async {
    try {
      await _localTextContentService.deleteTypedContent(noteId, contentId);
      if (user != null && user.remoteSave) {
        await _remoteTextContentService.deleteTypedContent(noteId, contentId);
      }
    } on Exception catch (_) {
      rethrow;
    }
  }

  TextContent _fromDto(TextcontentDto content) {
    return TextContent(
      id: content.id, 
      createdAt: content.createdAt, 
      lastEdited: content.lastEdited, 
      position: content.position, 
      text: content.text
    );
  }

}