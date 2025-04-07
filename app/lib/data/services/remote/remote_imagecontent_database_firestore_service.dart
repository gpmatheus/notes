
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/data/services/interfaces/image_content_service.dart';
import 'package:notes/data/services/interfaces/model/content/content_dto.dart';
import 'package:notes/data/services/interfaces/model/content/types/image/imagecontent_dto.dart';

class RemoteImagecontentDatabaseFirestoreService implements ImageContentService {

  final FirebaseFirestore _firestore;

  RemoteImagecontentDatabaseFirestoreService({
    required FirebaseFirestore firestore,
  }) :
    _firestore = firestore;

  @override
  Future<ImagecontentDto?> createImageContent(ImagecontentDto content) {
    // TODO: implement createImageContent
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTypedContent(String noteId, String contentId) {
    // TODO: implement deleteTypedContent
    throw UnimplementedError();
  }

  @override
  Future<ContentDto?> getContentById(String noteId, String id) {
    // TODO: implement getContentById
    throw UnimplementedError();
  }

  @override
  Future<List<ContentDto>> getContents(String noteId) {
    // TODO: implement getContents
    throw UnimplementedError();
  }

  @override
  Future<ImagecontentDto?> updateImageContent(String contentId, ImagecontentDto content) {
    // TODO: implement updateImageContent
    throw UnimplementedError();
  }

}