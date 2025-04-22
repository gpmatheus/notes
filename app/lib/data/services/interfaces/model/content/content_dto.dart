
class ContentDto {
  ContentDto({
    required this.id, 
    required this.createdAt, 
    required this.lastEdited, 
    required this.position,
    required this.noteId,
  });

  final String id;
  final DateTime createdAt;
  final DateTime? lastEdited;
  final int position;
  final String noteId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContentDto &&
      other.id == id &&
      other.createdAt.compareTo(createdAt) == 0 &&
      ((other.lastEdited == lastEdited) || 
        ((other.lastEdited != null && lastEdited != null) && 
        (other.lastEdited!.compareTo(lastEdited!) == 0))) &&
      other.position == position &&
      other.noteId == noteId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      createdAt.hashCode ^
      lastEdited.hashCode ^
      position.hashCode ^
      noteId.hashCode;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'lastEdited': lastEdited?.toIso8601String(),
      'position': position,
      'noteId': noteId,
    };
  }
}