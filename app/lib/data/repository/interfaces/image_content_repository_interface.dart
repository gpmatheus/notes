
import 'dart:typed_data';

import 'package:notes/data/repository/interfaces/utils/content_type_repository_interface.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/user/user.dart';

abstract class ImageContentRepositoryInterface extends ContentTypeRepositoryInterface {

  Future<Content> createContent(
    String noteId, 
    Uint8List bytes,
    int? position,
    User? user
  );
  Future<Content> updateContent(
    String contentId, 
    String noteId,
    Uint8List bytes,
    User? user,
  );
}