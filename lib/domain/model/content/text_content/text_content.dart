
import 'package:flutter/material.dart';
import 'package:notes/config/types.dart';
import 'package:notes/domain/model/content/content.dart';

@immutable
class TextContent extends Content {
  const TextContent({
    required super.id, 
    required super.createdAt, 
    required super.lastEdited, 
    required super.position,
    required this.text,
  });

  final String text;

  factory TextContent.fromJson(Map<String, Object?> json) {
    return TextContent(
      id: json['id'] as String, 
      createdAt: DateTime.tryParse(json['created_at'] as String) ?? DateTime.now(), 
      lastEdited: DateTime.tryParse(json['last_edited'] as String), 
      position: json['position'] as int, 
      text: json['text'] as String,
    );
  }

  Content copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? lastEdited,
    int? position,
    String? text,
  }) {
    return TextContent(
      id: id ?? super.id, 
      createdAt: createdAt ?? super.createdAt, 
      lastEdited: lastEdited ?? super.lastEdited, 
      position: position ?? super.position, 
      text: text ?? this.text,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return {
      ...super.toJson(),
      'text': text,
    };
  }

  @override
  String toString() {
    return 'TextContent extends Content('
      'id: ${super.id},'
      'createdAt: $createdAt,'
      'lastEdited: $lastEdited,'
      'position: $position,'
      'text: $text'
    ')';
  }

  @override
  bool operator ==(Object other) {
    return other is TextContent &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.lastEdited == lastEdited &&
      other.position == position &&
      other.text == text;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      createdAt,
      lastEdited,
      position,
      text,
    );
  }

  @override
  Types get type => Types.text;
  
  @override
  Content changePosition(int position) {
    return copyWith(position: position);
  }

}