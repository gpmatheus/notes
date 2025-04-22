
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/data/services/interfaces/content_service.dart';
import 'package:notes/data/services/interfaces/model/content/content_dto.dart';
import 'package:notes/data/services/interfaces/model/exceptions/not_found_exception.dart';

class RemoteContentDatabaseFirestoreService implements ContentService {

  late final FirebaseFirestore _firestore;

  @override
  Future<ContentDto> getContentById(String noteId, String contentId) async {
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
  Future<void> switchPositions(String noteId, String firstContentId, String secondContentId) async {
    ContentDto firstContent = (await getContentById(noteId, firstContentId));
    ContentDto secondContent = (await getContentById(noteId, secondContentId));

    await _firestore.runTransaction((transaction) async {

      transaction.update(
        _firestore.collection('notes')
            .doc(noteId)
            .collection('contents')
            .doc(firstContentId), 
        {'position': secondContent.position}
      );

      transaction.update(
        _firestore.collection('notes')
            .doc(noteId)
            .collection('contents')
            .doc(secondContentId), 
        {'position': firstContent.position}
      );
    });
  }

  @override
  Future<ContentDto> updateContent(String noteId, String contentId, ContentDto contentDto) async {
    await _firestore.collection('notes')
        .doc(noteId)
        .collection('contents')
        .doc(contentId)
        .set(contentDto.toJson(), SetOptions(merge: true));
    return contentDto;
  }

}