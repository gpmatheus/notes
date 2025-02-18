
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

}