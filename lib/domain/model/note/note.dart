
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notes/domain/model/content/content.dart';

@immutable
class Note {

  const Note({
    required this.id,
    required this.name,
    required this.contents,
    required this.createdAt,
    required this.lastEdited,
  });

  final String id;
  final String name;
  final List<Content>? contents;
  final DateTime createdAt;
  final DateTime? lastEdited;

  factory Note.fromJson(Map<String, Object?> json) {
    return Note(
      id: json['id'] as String,
      name: json['name'] as String,
      contents: null,
      createdAt: DateTime.tryParse(json['created_at'] as String) ?? DateTime.now(),
      lastEdited: DateTime.tryParse(json['last_edited'] as String),
    );
  }

  Note copyWith({
    String? id,
    String? name,
    required List<Content>? contents,
    DateTime? createdAt,
    required DateTime? lastEdited,
  }) {
    return Note(
      id: id ?? this.id,
      name: name ?? this.name,
      contents: contents ?? this.contents,
      createdAt: createdAt ?? this.createdAt,
      lastEdited: lastEdited ?? this.lastEdited,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'contents': contents == null ? null : [
        for (Content con in contents!)
          con.toJson()
      ],
      'created_at': createdAt.toIso8601String(),
      'last_edited': lastEdited?.toIso8601String(), 
    };
  }

  @override
  String toString() {
    return 'Note('
      'id: $id,'
      'name: $name,'
      'contents: List<Content>#${contents != null ? contents!.length : 'null'},'
      'createdAt: $createdAt,'
      'lastEdited: $lastEdited'
    ')';
  }

  @override
  bool operator ==(Object other) {
    return other is Note &&
      other.runtimeType == runtimeType &&
      other.id == id &&
      other.name == name &&
      other.contents == contents &&
      other.createdAt == createdAt &&
      other.lastEdited == lastEdited;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      contents,
      createdAt,
      lastEdited
    );
  }
  
}