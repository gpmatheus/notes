
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:notes/data/repository/interfaces/image_content_repository_interface.dart';
import 'package:notes/data/services/file/interfaces/image_file_service_interface.dart';
import 'package:notes/data/services/file/interfaces/models/imagefile_dto.dart';
import 'package:notes/data/services/local/interfaces/local_content_service.dart';
import 'package:notes/data/services/local/interfaces/local_image_content_service.dart';
import 'package:notes/data/services/local/interfaces/model/content/types/image/imagecontent_dto.dart';
import 'package:notes/data/services/local/interfaces/model/exceptions/invalid_input_exception.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/content/image_content/image_content.dart';
import 'package:notes/utils/formatted_logger.dart';
import 'package:uuid/uuid.dart';

class ImageContentRepository implements ImageContentRepositoryInterface {

  ImageContentRepository({
    required LocalImageContentService imageContentService,
    required ImageFileServiceInterface fileService,
    required LocalContentService localContentService,
  }) : 
    _imageContentService = imageContentService,
    _localContentService = localContentService,
    _fileService = fileService;


  final LocalImageContentService _imageContentService;
  final LocalContentService _localContentService;
  final ImageFileServiceInterface _fileService;
  final Logger _logger = FormattedLogger.instance;

  @override
  Future<Content?> createContent({
    required String noteId, 
    required File file,
    required int? position}) async {

    position = await _localContentService.getContentsCount(noteId);

    ImagefileDto? imageFile = await _fileService.saveImage(file);

    if (imageFile == null) return null;
    
    final ImagecontentDto? result = await _imageContentService.createImageContent(
      ImagecontentDto(
        id: const Uuid().v4(), 
        createdAt: DateTime.now(), 
        lastEdited: null, 
        position: position, 
        imageFileName: imageFile.imageFileName, 
        noteId: noteId
      )
    );
    if (result == null) return null;
    
    return _fromDto(result, imageFile.file);
  }

  @override
  Future<Content?> getContent(String contentId) async {
    final ImagecontentDto? result = await 
      _imageContentService.getContentById(contentId) as ImagecontentDto?;
    if (result == null) return null;
    
    final File? imageFile = await 
      _fileService.getImage(result.imageFileName);
    if (imageFile == null) return null;
    
    return _fromDto(result, imageFile);
  }

  @override
  Future<List<Content>> getContents(String noteId) async {
    final List<ImagecontentDto> result = (await 
      _imageContentService.getContents(noteId)).map<ImagecontentDto>(
        (con) => (con as ImagecontentDto)
      ).toList();
    
    List<ImageContent> contents = [];
    for (var res in result) {
      final File? imageFile = await _fileService.getImage(res.imageFileName);
      if (imageFile == null) continue;
      contents.add(
        _fromDto(res, imageFile)!
      );
    }
    return contents;
  }

  @override
  Future<Content?> updateContent({
    required String contentId, 
    required String noteId,
    required File file,
    }) async {
    
    final ImagecontentDto? contentDto = await 
      _imageContentService.getContentById(contentId) as ImagecontentDto?;
    if (contentDto == null) throw InvalidInputException('Content not found');

    try {
      final ImagefileDto? imageFile = await _fileService.substituteImage(contentDto.imageFileName, file.path);
      if (imageFile == null) return null;

      final ImagecontentDto? updatedContent = await _imageContentService.updateImageContent(
        contentId, 
        ImagecontentDto(
          id: contentDto.id, 
          createdAt: contentDto.createdAt, 
          lastEdited: DateTime.now(), 
          position: contentDto.position, 
          imageFileName: imageFile.imageFileName, 
          noteId: noteId
        )
      );
      if (updatedContent == null) return null;
      return _fromDto(updatedContent, imageFile.file);
    } on InvalidInputException {
      rethrow;
    } on Exception catch (e) {
      _logger.e('Error updating content: $e');
      return null;
    }
  }

  ImageContent? _fromDto(ImagecontentDto content, File file) {
    return ImageContent(
      id: content.id, 
      createdAt: content.createdAt, 
      lastEdited: content.lastEdited, 
      position: content.position, 
      imageFileName: content.imageFileName, 
      file: file
    );
  }
  
  @override
  Future<bool> deleteTypedContent(String contentId) async {
    try {
      ImagecontentDto? result = await
          _imageContentService.getContentById(contentId) as ImagecontentDto?;
      if (result == null) return false;
      final bool fileDeleted = await _fileService.deleteImage(result.imageFileName);
      if (fileDeleted) {
        await _imageContentService.deleteTypedContent(contentId);
      }
      return fileDeleted;
    } on Exception catch (e) {
      _logger.e('Error deleting content: $e');
      return false;
    }
  }

}