

import 'dart:convert';

import 'package:notes/domain/entities/content.dart';
import 'package:uuid/uuid.dart';

class Note {
  final String id;
  final String name;
  List<Content>? contents;
  final DateTime createdAt;
  DateTime? lastEdited;
  List<int> contentPositions;

  Note({
    String? id,
    required this.name,
    this.contents,
    DateTime? createdAt,
    this.lastEdited,
    required this.contentPositions,
  }) :
    id = id ?? const Uuid().v4(),
    createdAt = createdAt ?? DateTime.now();

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'last_edited': lastEdited?.toIso8601String(),
      'content_positions': jsonEncode(contentPositions)
    };
  }

}