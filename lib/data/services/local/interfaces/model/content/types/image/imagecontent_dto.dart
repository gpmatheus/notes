
import 'package:notes/data/services/local/interfaces/model/content/content_dto.dart';

class ImagecontentDto extends ContentDto {

  ImagecontentDto({
    required super.id, 
    required super.createdAt, 
    required super.lastEdited, 
    required super.position,
    required this.imageFileName, 
    required super.noteId,
  });

  final String imageFileName;

}