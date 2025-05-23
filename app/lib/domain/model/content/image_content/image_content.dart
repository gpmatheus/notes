
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:notes/config/types.dart';
import 'package:notes/domain/model/content/content.dart';

@immutable
class ImageContent extends Content {
  const ImageContent({
    required super.id, 
    required super.createdAt, 
    required super.lastEdited, 
    required super.position,
    required this.imageFileName,
    required this.bytes,
  });

  final String imageFileName;
  final Uint8List? bytes;

  factory ImageContent.fromJson(Map<String, Object?> json) {
    return ImageContent(
      id: json['id'] as String, 
      createdAt: DateTime.tryParse(json['created_at'] as String) ?? DateTime.now(), 
      lastEdited: DateTime.tryParse(json['last_edited'] as String), 
      position: json['position'] as int, 
      imageFileName: json['image_file_name'] as String,
      bytes: null,
    );
  }

  Content copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? lastEdited,
    int? position,
    String? imageFileName,
    Uint8List? bytes,
  }) {
    return ImageContent(
      id: id ?? super.id, 
      createdAt: createdAt ?? super.createdAt, 
      lastEdited: lastEdited ?? super.lastEdited, 
      position: position ?? super.position, 
      imageFileName: imageFileName ?? this.imageFileName,
      bytes: bytes ?? this.bytes,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return {
      ...super.toJson(),
      'image_file_name': imageFileName,
    };
  }

  @override
  String toString() {
    return 'ImageContent extends Content('
      'id: ${super.id},'
      'createdAt: $createdAt,'
      'lastEdited: $lastEdited,'
      'position: $position,'
      'imageFileName: $imageFileName,'
      'bytes_len: ${bytes?.length}'
    ')';
  }

  @override
  bool operator ==(Object other) {
    return other is ImageContent &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.lastEdited == lastEdited &&
      other.position == position &&
      other.imageFileName == imageFileName &&
      other.bytes == bytes;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      createdAt,
      lastEdited,
      position,
      imageFileName,
    );
  }

  @override
  Types get type => Types.image;
  
  @override
  Content changePosition(int position) {
    return copyWith(position: position);
  }

}