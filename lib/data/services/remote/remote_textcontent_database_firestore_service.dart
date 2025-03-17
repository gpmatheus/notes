
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/data/services/interfaces/text_content_service.dart';
import 'package:notes/data/services/interfaces/model/content/content_dto.dart';
import 'package:notes/data/services/interfaces/model/content/types/text/textcontent_dto.dart';

class RemoteTextcontentDatabaseFirestoreService implements TextContentService {

  final FirebaseFirestore _firestore;

  RemoteTextcontentDatabaseFirestoreService({
    required FirebaseFirestore firestore,
  }) :
    _firestore = firestore;

  @override
  Future<TextcontentDto?> createTextContent(TextcontentDto content) {
    // TODO: implement createTextContent
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
  Future<TextcontentDto?> updateTextContent(String contentId, TextcontentDto content) {
    // TODO: implement updateTextContent
    throw UnimplementedError();
  }

}