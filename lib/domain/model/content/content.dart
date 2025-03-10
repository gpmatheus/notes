
import 'package:flutter/material.dart';
import 'package:notes/config/types.dart';

@immutable
abstract class Content {

  const Content({
    required this.id,
    required this.createdAt,
    required this.lastEdited,
    required this.position,
  });

  final String id;
  final DateTime createdAt;
  final DateTime? lastEdited;
  final int position;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'last_edited': lastEdited,
      'position': position,
    };
  }

  Content changePosition(int position);

  Types get type;

}