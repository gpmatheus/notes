
class NoteDto {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime? lastEdited;

  NoteDto({
    required this.id, 
    required this.name, 
    required this.createdAt, 
    required this.lastEdited,
  });

  factory NoteDto.fromJson(Map<String, Object?> json) {
    return NoteDto(
      id: json['id'] as String, 
      name: json['name'] as String, 
      createdAt: DateTime.tryParse(json['created_at'] as String) ?? DateTime.now(),
      lastEdited: DateTime.tryParse(json['last_edited'] as String), 
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      if (lastEdited != null) ... {
        'last_edited': lastEdited!.toIso8601String(),
      }
    };
  }

}