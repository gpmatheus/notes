
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/data/services/interfaces/content_service.dart';
import 'package:notes/data/services/interfaces/model/content/content_dto.dart';
import 'package:notes/data/services/interfaces/model/exceptions/not_found_exception.dart';

class RemoteContentDatabaseFirestoreService implements ContentService {

  final FirebaseFirestore _firestore;

  RemoteContentDatabaseFirestoreService({
    required FirebaseFirestore firestore,
  }) :
    _firestore = firestore;

  @override
  Future<ContentDto?> getContentById(String noteId, String contentId) async {
     ContentDto? note = await _firestore.collection('notes')
      .doc(noteId)
      .collection('contents')
      .doc(contentId)
      .get()
      .then((snapshot) => snapshot.data() as ContentDto?);
    
    if (note == null) throw NotFoundException('Content could not be found');
    return note;
  }

  @override
  Future<List<ContentDto>> getContents(String noteId) async {
    return (await _firestore
        .collection('notes')
        .doc(noteId)
        .collection('contents')
        .get())
        .docs.map((doc) => doc.data() as ContentDto).toList();
  }

  @override
  Future<int> getContentsCount(String noteId) async {
    int? count = (await _firestore
        .collection('notes')
        .doc(noteId)
        .collection('contents')
        .count()
        .get()).count;
    
    return count ?? 0;
  }

  @override
  Future<void> switchPositions(String noteId, String firstContentId, String secondContentId) {
    // TODO: implement switchPositions
    throw UnimplementedError();
  }

  @override
  Future<ContentDto?> updateContent(String noteId, String contentId, ContentDto contentDto) {
    // TODO: implement updateContent
    throw UnimplementedError();
  }

}