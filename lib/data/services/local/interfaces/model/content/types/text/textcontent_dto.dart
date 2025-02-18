
import 'package:notes/data/services/local/interfaces/model/content/content_dto.dart';

class TextcontentDto extends ContentDto {
  TextcontentDto({
    required super.id, 
    required super.createdAt, 
    required super.lastEdited, 
    required super.position,
    required this.text, 
    required super.noteId,
  });

  final String text;

}