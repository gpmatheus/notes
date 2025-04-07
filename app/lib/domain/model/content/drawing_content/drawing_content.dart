
import 'package:notes/config/types.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/content/drawing_content/drawing.dart';

class DrawingContent extends Content {
  const DrawingContent({
    required super.id, 
    required super.createdAt, 
    required super.lastEdited, 
    required super.position,
    required this.drawing,
  });

  final Drawing drawing;

  factory DrawingContent.fromJson(Map<String, Object?> json) {
    return DrawingContent(
      id: json['id'] as String, 
      createdAt: DateTime.tryParse(json['created_at'] as String) ?? DateTime.now(), 
      lastEdited: DateTime.tryParse(json['last_edited'] as String), 
      position: json['position'] as int, 
      drawing: Drawing.fromJson(json['draw'] as Map<String, Object?>)
    );
  }

  Content copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? lastEdited,
    int? position,
    String? imageFileName,
    Drawing? drawing,
  }) {
    return DrawingContent(
      id: id ?? super.id, 
      createdAt: createdAt ?? super.createdAt, 
      lastEdited: lastEdited ?? super.lastEdited, 
      position: position ?? super.position, 
      drawing: drawing ?? this.drawing,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return {
      ...super.toJson(),
      'draw': drawing.toJson(),
    };
  }

  @override
  String toString() {
    return 'DrawingContent extends Content('
      'id: ${super.id},'
      'createdAt: $createdAt,'
      'lastEdited: $lastEdited,'
      'position: $position,'
      'drawing: Drawing()'
    ')';
  }

  @override
  bool operator ==(Object other) {
    return other is DrawingContent &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.lastEdited == lastEdited &&
      other.position == position;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      createdAt,
      lastEdited,
      position,
      drawing,
    );
  }

  @override
  Types get type => Types.image;
  
  @override
  Content changePosition(int position) {
    return copyWith(position: position);
  }

}