
import 'dart:io';

import 'package:notes/data/repository/interfaces/image_content_repository_interface.dart';
import 'package:notes/data/services/file/interfaces/image_file_service_interface.dart';
import 'package:notes/data/services/file/interfaces/models/imagefile_dto.dart';
import 'package:notes/data/services/local/interfaces/local_image_content_service.dart';
import 'package:notes/data/services/local/interfaces/model/content/types/image/imagecontent_dto.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/content/image_content/image_content.dart';
import 'package:uuid/uuid.dart';

class ImageContentRepository implements ImageContentRepositoryInterface {

  ImageContentRepository({
    required LocalImageContentService imageContentService,
    required ImageFileServiceInterface fileService,
  }) : 
    _imageContentService = imageContentService,
    _fileService = fileService;


  final LocalImageContentService _imageContentService;
  final ImageFileServiceInterface _fileService;

  @override
  Future<Content?> createContent({
    required String noteId, 
    required File file,
    required int position}) async {

    if (position < 0) return null;

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
  Future<bool> deleteContent(String contentId) async {
    final bool deleted = await _imageContentService.deleteTypedContent(contentId);
    if (deleted) {
      ImagecontentDto? result = await
        _imageContentService.getContnetById(contentId) as ImagecontentDto?;
      if (result != null) {
        final bool fileDeleted = await _fileService.deleteImage(result.imageFileName);
        return fileDeleted;
      }
    }
    return deleted;
  }

  @override
  Future<Content?> getContent(String contentId) async {
    final ImagecontentDto? result = await 
      _imageContentService.getContnetById(contentId) as ImagecontentDto?;
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
    required int position}) async {
    
    final ImagecontentDto? contentDto = await 
      _imageContentService.getContnetById(contentId) as ImagecontentDto?;
    if (contentDto == null) return null;

    final ImagefileDto? imageFile = await _fileService.substituteImage(contentDto.imageFileName, file.path);
    if (imageFile == null) return null;

    final ImagecontentDto? updatedContent = await _imageContentService.updateImageContent(
      contentId, 
      ImagecontentDto(
        id: contentDto.id, 
        createdAt: contentDto.createdAt, 
        lastEdited: DateTime.now(), 
        position: position, 
        imageFileName: imageFile.imageFileName, 
        noteId: noteId
      )
    );
    if (updatedContent == null) return null;
    return _fromDto(updatedContent, imageFile.file);
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
    return await _imageContentService.deleteTypedContent(contentId);
  }

}