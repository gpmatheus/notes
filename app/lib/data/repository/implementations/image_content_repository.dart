
import 'dart:typed_data';

import 'package:notes/data/repository/interfaces/image_content_repository_interface.dart';
import 'package:notes/data/services/interfaces/content_type_service.dart';
import 'package:notes/data/services/interfaces/image_file_service_interface.dart';
import 'package:notes/data/services/interfaces/model/file/imagefile_dto.dart';
import 'package:notes/data/services/interfaces/content_service.dart';
import 'package:notes/data/services/interfaces/image_content_service.dart';
import 'package:notes/data/services/interfaces/model/content/types/image/imagecontent_dto.dart';
import 'package:notes/data/services/interfaces/model/exceptions/invalid_input_exception.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/content/image_content/image_content.dart';
import 'package:notes/domain/model/user/user.dart';
import 'package:uuid/uuid.dart';

class ImageContentRepository implements ImageContentRepositoryInterface {

  ImageContentRepository({
    required ImageContentService imageContentService,
    required ImageContentService remoteImageContentService,
    required ImageFileServiceInterface fileService,
    required ImageFileServiceInterface remoteFileService,
    required ContentService localContentService,
    required ContentService remoteContentService,
  }) : 
    _imageContentService = imageContentService,
    _remoteImageContentService = remoteImageContentService,
    _localContentService = localContentService,
    _fileService = fileService,
    _remoteContentService = remoteContentService,
    _remoteFileService = remoteFileService;


  final ImageContentService _imageContentService;
  final ImageContentService _remoteImageContentService;
  final ContentService _localContentService;
  // ignore: unused_field
  final ContentService _remoteContentService;
  final ImageFileServiceInterface _fileService;
  final ImageFileServiceInterface _remoteFileService;

  @override
  Future<Content> createContent(
    String noteId, 
    Uint8List bytes,
    int? position,
    User? user) async {

    position = await _localContentService.getContentsCount(noteId);

    final String imageFileName = '${const Uuid().v4()}.png';
    ImagefileDto imageFile = await _fileService.saveImage(
      ImagefileDto(
        bytes: bytes,
        imageFileName: imageFileName,
      )
    );
    
    final ImagecontentDto result = await _imageContentService.createImageContent(
      ImagecontentDto(
        id: const Uuid().v4(), 
        createdAt: DateTime.now(), 
        lastEdited: null, 
        position: position, 
        imageFileName: imageFile.imageFileName, 
        noteId: noteId
      )
    );
    
    return _fromDto(result, imageFile.bytes);
  }

  @override
  Future<Content> getContent(String noteId, String contentId, User? user) async {
    try {
      if (user == null || !user.remoteSave) {
        ImagecontentDto content = await _imageContentService
          .getContentById(noteId, contentId) as ImagecontentDto;
        
        Uint8List file = await _fileService.getImage(content.imageFileName);
        return _fromDto(content, file);
      } else {
        ImagecontentDto content = await _remoteImageContentService
          .getContentById(noteId, contentId) as ImagecontentDto;
        
        Uint8List file = await _remoteFileService.getImage(content.imageFileName);
        return _fromDto(content, file);
      }
    } on InvalidInputException {
      rethrow;
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<Content>> getContents(String noteId, User? user) async {
    final bool remote = user != null && user.remoteSave;

    final ContentTypeService service = remote ? _remoteImageContentService : _imageContentService;
    final ImageFileServiceInterface fileService = remote ? _remoteFileService : _fileService;

    final List<ImagecontentDto> result = (await 
      service.getContents(noteId)).map<ImagecontentDto>(
        (con) => (con as ImagecontentDto)
      ).toList();
    
    List<ImageContent> contents = [];
    for (var res in result) {
      final Uint8List imageFile = await fileService.getImage(res.imageFileName);
      contents.add(
        _fromDto(res, imageFile)
      );
    }
    return contents;
  }

  @override
  Future<Content> updateContent(
    String contentId, 
    String noteId,
    Uint8List bytes,
    User? user) async {
    
    final ImagecontentDto? contentDto = await 
      _imageContentService.getContentById(noteId, contentId) as ImagecontentDto?;
    if (contentDto == null) throw InvalidInputException('Content not found');

    try {
      final ImagefileDto imageFile = await _fileService.substituteImage(
        contentDto.imageFileName, 
        ImagefileDto(
          bytes: bytes, 
          imageFileName: contentDto.imageFileName,
        )
      );

      final ImagecontentDto updatedContent = await _imageContentService.updateImageContent(
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
      return _fromDto(updatedContent, imageFile.bytes);
    } on InvalidInputException {
      rethrow;
    } on Exception catch (_) {
      rethrow;
    }
  }

  ImageContent _fromDto(ImagecontentDto content, Uint8List file) {
    return ImageContent(
      id: content.id, 
      createdAt: content.createdAt, 
      lastEdited: content.lastEdited, 
      position: content.position, 
      imageFileName: content.imageFileName, 
      bytes: file
    );
  }
  
  @override
  Future<bool> deleteTypedContent(String noteId, String contentId, User? user) async {
    try {
      final ContentTypeService service = (user == null || !user.remoteSave)
        ? _imageContentService
        : _remoteImageContentService;
      ImagecontentDto result = await
          service.getContentById(noteId, contentId) as ImagecontentDto;
      
      bool fileDeleted = await _fileService.deleteImage(result.imageFileName);
      fileDeleted = fileDeleted && (await _remoteFileService.deleteImage(result.imageFileName));
      if (fileDeleted) {
        await _imageContentService.deleteTypedContent(noteId, contentId);
        await _remoteImageContentService.deleteTypedContent(noteId, contentId);
      }
      return fileDeleted;
    } on Exception catch (_) {
      return false;
    }
  }

}