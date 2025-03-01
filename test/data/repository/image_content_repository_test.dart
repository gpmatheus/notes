

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:notes/data/repository/implementations/image_content_repository.dart';
import 'package:notes/data/repository/interfaces/image_content_repository_interface.dart';
import 'package:notes/data/services/file/interfaces/image_file_service_interface.dart';
import 'package:notes/data/services/file/interfaces/models/imagefile_dto.dart';
import 'package:notes/data/services/local/interfaces/local_image_content_service.dart';
import 'package:notes/data/services/local/interfaces/model/content/types/image/imagecontent_dto.dart';
import 'package:notes/domain/model/content/content.dart';

import 'image_content_repository_test.mocks.dart';

@GenerateMocks([LocalImageContentService, ImageFileServiceInterface])
void main() {

  late ImageContentRepositoryInterface repository;
  late MockLocalImageContentService service;
  late MockImageFileServiceInterface fileService;

  group('Test ImageContentRepository implements ImageContentRepositoryInterface', () {

    group('test the createImageContent method', () {

      setUp(() {
        service = MockLocalImageContentService();
        fileService = MockImageFileServiceInterface();
        repository = ImageContentRepository(
          imageContentService: service,
          fileService: fileService,
        );
      });

      test('should return a ImageContent when valid information is provided', () async {
        // arrange
        const noteId = 'noteId';
        const position = 0;
        final validFile = File('file');
        final imageFile = ImagefileDto(
          imageFileName: 'imageFileName.png',
          file: validFile,
        );
        final contentDto = ImagecontentDto(
          id: 'id',
          createdAt: DateTime.now(),
          lastEdited: null,
          position: position,
          imageFileName: imageFile.imageFileName,
          noteId: noteId,
        );
        when(fileService.saveImage(validFile)).thenAnswer((_) async => imageFile);
        when(service.createImageContent(any)).thenAnswer((_) async => contentDto);
        // act
        Content? result = await repository.createContent(
          noteId: noteId,
          file: validFile,
          position: position,
        );
        // assert
        expect(result, isNotNull);
        expect(result!.id, 'id');
        verify(fileService.saveImage(any));
        verify(service.createImageContent(any));
      });

      test('should return null when invalid file is provided', () async {
        // arrange
        const noteId = 'noteId';
        const position = 0;
        final invalidFile = File('invalidFile');
        when(fileService.saveImage(invalidFile)).thenAnswer((_) async => null);
        // act
        Content? result = await repository.createContent(
          noteId: noteId,
          file: invalidFile,
          position: position,
        );
        // assert
        expect(result, isNull);
        verify(fileService.saveImage(invalidFile));
        verifyNever(service.createImageContent(any));
      });

      test('should return null when negative file is provided', () async {
        // arrange
        const noteId = 'noteId';
        final invalidFile = File('invalidFile');
        // act
        Content? result = await repository.createContent(
          noteId: noteId,
          file: invalidFile,
          position: -1,
        );
        // assert
        expect(result, isNull);
        verifyNever(fileService.saveImage(invalidFile));
        verifyNever(service.createImageContent(any));
      });

    });

    group('test the deleteContent method', () {

      setUp(() {
        service = MockLocalImageContentService();
        fileService = MockImageFileServiceInterface();
        repository = ImageContentRepository(
          imageContentService: service,
          fileService: fileService,
        );
      });

      test('should return true when valid information is provided', () async {
        // arrange
        const contentId = 'contentId';
        const imageFileName = 'imageFileName.png';
        final contentDto = ImagecontentDto(
          id: contentId,
          createdAt: DateTime.now(),
          lastEdited: null,
          position: 0,
          imageFileName: imageFileName,
          noteId: 'noteId',
        );
        when(service.deleteTypedContent(contentId)).thenAnswer((_) async => true);
        when(service.getContnetById(contentId)).thenAnswer((_) async => contentDto);
        when(fileService.deleteImage(any)).thenAnswer((_) async => true);
        // act
        final result = await repository.deleteContent(contentId);
        // assert
        expect(result, true);
        verify(service.deleteTypedContent(contentId));
        verify(service.getContnetById(contentId));
        verify(fileService.deleteImage(any));
      });

      test('should return false when invalid contentId is provided', () async {
        // arrange
        const contentId = 'contentId';
        when(service.deleteTypedContent(any)).thenAnswer((_) async => false);
        when(service.getContnetById(any)).thenAnswer((_) async => null);
        // act
        final result = await repository.deleteContent(contentId);
        // assert
        expect(result, false);
        verifyNever(service.deleteTypedContent(contentId));
      });

    });

    group('test the updateContent method', () {
      
      setUp(() {
        service = MockLocalImageContentService();
        fileService = MockImageFileServiceInterface();
        repository = ImageContentRepository(
          imageContentService: service,
          fileService: fileService,
        );
      });

      test('should return a ImageContent when valid information is provided', () async {
        // arrange
        const contentId = 'contentId';
        const noteId = 'noteId';
        const position = 0;
        final validFile = File('file');
        final imageFile = ImagefileDto(
          imageFileName: 'imageFileName.png',
          file: validFile,
        );
        final contentDto = ImagecontentDto(
          id: contentId,
          createdAt: DateTime.now(),
          lastEdited: null,
          position: position,
          imageFileName: imageFile.imageFileName,
          noteId: noteId,
        );
        when(service.getContnetById(contentId)).thenAnswer((_) async => contentDto);
        when(fileService.saveImage(validFile)).thenAnswer((_) async => imageFile);
        when(fileService.substituteImage('imageFileName.png', 'file')).thenAnswer((_) async => imageFile);
        when(service.updateImageContent(any, any)).thenAnswer((_) async => contentDto);
        // act
        Content? result = await repository.updateContent(
          contentId: contentId,
          noteId: noteId,
          file: validFile,
          position: position,
        );
        // assert
        expect(result, isNotNull);
        expect(result!.id, contentId);
        verify(fileService.saveImage(any));
        verify(service.updateImageContent(any, any));
      });

      test('should return null when invalid file is provided', () async {
        // arrange
        const contentId = 'contentId';
        const noteId = 'noteId';
        const position = 0;
        final invalidFile = File('invalidFile');
        when(fileService.saveImage(invalidFile)).thenAnswer((_) async => null);
        // act
        Content? result = await repository.updateContent(
          contentId: contentId,
          noteId: noteId,
          file: invalidFile,
          position: position,
        );
        // assert
        expect(result, isNull);
        verify(fileService.saveImage(invalidFile));
        verifyNever(service.updateImageContent(any, any));
      });

      test('should return null when negative file is provided', () async {
        // arrange
        const contentId = 'contentId';
        const noteId = 'noteId';
        final invalidFile = File('invalidFile');
        // act
        Content? result = await repository.updateContent(
          contentId: contentId,
          noteId: noteId,
          file: invalidFile,
          position: -1,
        );
        // assert
        expect(result, isNull);
        verifyNever(fileService.saveImage(invalidFile));
        verifyNever(service.updateImageContent(any, any));
      });
    });
    
  });
}