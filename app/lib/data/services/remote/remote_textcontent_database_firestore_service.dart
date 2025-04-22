
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/data/services/interfaces/model/exceptions/invalid_input_exception.dart';
import 'package:notes/data/services/interfaces/model/exceptions/not_found_exception.dart';
import 'package:notes/data/services/interfaces/text_content_service.dart';
import 'package:notes/data/services/interfaces/model/content/content_dto.dart';
import 'package:notes/data/services/interfaces/model/content/types/text/textcontent_dto.dart';

class RemoteTextcontentDatabaseFirestoreService implements TextContentService {

  late final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<TextcontentDto> createTextContent(TextcontentDto content) async {
    if (content.id.isEmpty) {
      throw InvalidInputException("Content ID cannot be empty");
    }
    await _firestore.collection('notes')
        .doc(content.noteId)
        .collection('contents')
        .doc(content.id)
        .set({
          'created_at': content.createdAt.toIso8601String(),
          if (content.lastEdited != null) ... {
            'last_edited': content.lastEdited?.toIso8601String(),
          },
          'position': content.position,
        });
    
    await _firestore.collection('text_contents')
        .doc(content.id)
        .set({
          'text': content.text,
          'note_id': content.noteId,
        });
    return content;
  }

  @override
  Future<void> deleteTypedContent(String noteId, String contentId) async {
    return _firestore.collection('notes')
        .doc(noteId)
        .collection('contents')
        .doc(contentId)
        .delete()
        .then((_) {
          return _firestore.collection('text_contents')
              .doc(contentId)
              .delete();
        });
  }

  @override
  Future<ContentDto> getContentById(String noteId, String id) async {
    return _firestore.collection('notes')
        .doc(noteId)
        .collection('contents')
        .doc(id)
        .get()
        .then((snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data();
            return _firestore.collection('text_contents')
                .doc(id)
                .get()
                .then((textSnapshot) {
                  if (textSnapshot.exists) {
                    final textData = textSnapshot.data();
                    return TextcontentDto(
                      id: id,
                      noteId: noteId,
                      createdAt: DateTime.parse(data!['created_at']),
                      lastEdited: data['last_edited'] != null ? DateTime.parse(data['last_edited']) : null,
                      position: data['position'],
                      text: textData!['text'],
                    );
                  }
                  throw NotFoundException("Text content with ID $id not found");
                });
          }
          throw NotFoundException("Content with ID $id not found");
        });
  }

  @override
  Future<List<ContentDto>> getContents(String noteId) async {
    final contentRefs = await _firestore.collection('notes')
        .doc(noteId)
        .collection('contents')
        .get();
    

    final List<ContentDto> contents = [];
    for (var doc in contentRefs.docs) {
      final contentData = doc.data();
      final textContentRef = await _firestore.collection('text_contents')
          .doc(doc.id)
          .get();
      
      if (textContentRef.exists) {
        final textContentData = textContentRef.data();
        contents.add(
          TextcontentDto(
            id: doc.id,
            noteId: noteId,
            createdAt: DateTime.parse(contentData['created_at']),
            lastEdited: contentData['last_edited'] != null ? DateTime.parse(contentData['last_edited']) : null,
            position: contentData['position'],
            text: textContentData!['text'],
          ),
        );
      }
    }
    return contents;
  }

  @override
  Future<TextcontentDto> updateTextContent(String contentId, TextcontentDto content) async {
    _firestore.collection('text_contents')
        .doc(contentId)
        .update({
          'text': content.text,
        });
    return content;
  }

}