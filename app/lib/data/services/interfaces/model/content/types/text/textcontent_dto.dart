
import 'package:notes/data/services/interfaces/model/content/content_dto.dart';

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

  factory TextcontentDto.fromJson(Map<String, Object?> json) {
    return TextcontentDto(
      id: json['id'] as String,
      createdAt: DateTime.tryParse(json['created_at'] as String) ?? DateTime.now(),
      lastEdited: DateTime.tryParse(json['last_edited'] as String),
      position: (json['position'] as int?) ?? 0,
      text: json['text'] as String,
      noteId: json['note_id'] as String,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      if (lastEdited != null) ... {
        'last_edited': lastEdited!.toIso8601String(),
      },
      'position': position,
      'text': text,
      'note_id': noteId,
    };
  }

}