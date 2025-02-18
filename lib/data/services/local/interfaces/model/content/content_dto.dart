
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
}