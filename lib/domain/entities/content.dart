
import 'dart:convert';
import 'dart:io';

import 'package:notes/domain/contents/content_types.dart';
import 'package:notes/domain/entities/drawing.dart';
import 'package:uuid/uuid.dart';

abstract class Content {
  final String id;
  final DateTime createdAt;
  DateTime? lastEdited;

  Content({
    String? id,
    DateTime? createdAt,
    this.lastEdited,
  }) :
    id = id ?? const Uuid().v4(),
    createdAt = createdAt ?? DateTime.now();

  Map<String, Object?> toParentMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'last_edited': lastEdited?.toIso8601String(),
    };
  }

  Map<String, Object?> toChildMap();
  
  ContentsType contentsType();
}

class TextContent extends Content {
  final String text;

  final ContentsType _contentType = ContentsType.text;

  TextContent({required this.text});

  TextContent.existing({
    required super.id,
    required super.createdAt,
    required super.lastEdited,
    required this.text
  });

  @override
  ContentsType contentsType() {
    return _contentType;
  }
  
  @override
  Map<String, Object?> toChildMap() {
    return {
      'content_id': id,
      'text': text,
    };
  }

}

class ImageContent extends Content {
  String? imageFileName;
  File file;

  final ContentsType _contentType = ContentsType.image;

  ImageContent({required this.file});

  ImageContent.existing({
    required super.id,
    required super.createdAt,
    required super.lastEdited,
    required this.imageFileName,
    required this.file,
  });
  
  @override
  ContentsType contentsType() {
    return _contentType;
  }
  
  @override
  Map<String, Object?> toChildMap() {
    return {
      'content_id': id,
      'image_file_name': imageFileName,
    };
  }
  
}

class DrawingContent extends Content {
  final Drawing drawing;

  final ContentsType _contentType = ContentsType.drawing;

  DrawingContent(Map<String, dynamic> drawingData) :
    drawing = Drawing.fromJson(drawingData);
  
  DrawingContent.existing({
    required super.id,
    required super.createdAt,
    required super.lastEdited,
    required String draw
  }) :
    drawing = Drawing.fromJson(jsonDecode(draw));
    
  @override
  ContentsType contentsType() {
    return _contentType;
  }
  
  @override
  Map<String, Object?> toChildMap() {
    return {
      'content_id': id,
      'drawing': jsonEncode(drawing.toJson()),
    };
  }
  
}

