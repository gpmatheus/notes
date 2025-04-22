
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/data/services/interfaces/image_content_service.dart';
import 'package:notes/data/services/interfaces/model/content/content_dto.dart';
import 'package:notes/data/services/interfaces/model/content/types/image/imagecontent_dto.dart';
import 'package:notes/data/services/interfaces/model/exceptions/invalid_input_exception.dart';
import 'package:notes/data/services/interfaces/model/exceptions/not_found_exception.dart';

class RemoteImagecontentDatabaseFirestoreService implements ImageContentService {

  late final FirebaseFirestore _firestore;

  @override
  Future<ImagecontentDto> createImageContent(ImagecontentDto content) async {
    if (content.id.isEmpty) {
      throw InvalidInputException("Content ID cannot be empty");
    }
    return _firestore.collection('notes')
        .doc(content.noteId)
        .collection('contents')
        .doc(content.id)
        .set({
          'created_at': content.createdAt.toIso8601String(),
          if (content.lastEdited != null) ... {
            'last_edited': content.lastEdited?.toIso8601String(),
          },
          'position': content.position,
        })
        .then((_) {
          return _firestore.collection('image_contents')
              .doc(content.id)
              .set({
                'image_file_name': content.imageFileName,
                'note_id': content.noteId,
              })
              .then((_) => content);
        });
  }

  @override
  Future<void> deleteTypedContent(String noteId, String contentId) async {
    return _firestore.collection('notes')
        .doc(noteId)
        .collection('contents')
        .doc(contentId)
        .delete()
        .then((_) {
          return _firestore.collection('image_contents')
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
            return _firestore.collection('image_contents')
                .doc(id)
                .get()
                .then((imageSnapshot) {
                  if (imageSnapshot.exists) {
                    final data = imageSnapshot.data();
                    return ImagecontentDto(
                      id: id,
                      noteId: noteId,
                      createdAt: DateTime.parse(snapshot['created_at']),
                      lastEdited: snapshot['last_edited'] != null
                          ? DateTime.parse(snapshot['last_edited'])
                          : null,
                      position: snapshot['position'],
                      imageFileName: data?['image_file_name'] ?? '',
                    );
                  }
                  throw NotFoundException('Image content with id $id not found');
                });
          }
          throw NotFoundException('Content with id $id not found');
        });
  }

  @override
  Future<List<ContentDto>> getContents(String noteId) async {
    return _firestore.collection('notes')
        .doc(noteId)
        .collection('contents')
        .get()
        .then((snapshot) {
          final contents = <ContentDto>[];
          for (var doc in snapshot.docs) {
            final data = doc.data();
            contents.add(ImagecontentDto(
              id: doc.id,
              noteId: noteId,
              createdAt: DateTime.parse(data['created_at']),
              lastEdited: data['last_edited'] != null
                  ? DateTime.parse(data['last_edited'])
                  : null,
              position: data['position'],
              imageFileName: '',
            ));
          }
          return contents;
        });
  }

  @override
  Future<ImagecontentDto> updateImageContent(String contentId, ImagecontentDto content) async {
    await _firestore.collection('image_contents')
        .doc(contentId)
        .update({
          'image_file_name': content.imageFileName,
        });
    return content;
  }

}