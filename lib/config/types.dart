
import 'package:flutter/material.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/ui/note_details/widgets/image_content_display.dart';
import 'package:notes/ui/note_details/widgets/text_content_display.dart';

class Types {

  final String name;
  final Widget icon;
  final Widget Function(
    String noteId,
    Content? con,
    bool form,
    int position,
    Function(Content content)? onContentUpdated,
    Function()? onCancel,
    Function(String? message)? onError,
  ) display;

  const Types._build({
    required this.name, 
    required this.icon,
    required this.display,
  });

  static final all = [
    text,
    image,
  ];

  static final text = Types._build(
    name: 'Text', 
    icon: const Icon(Icons.text_fields_rounded), 
    display: (
      String noteId,
      Content? con,
      bool form,
      int position,
      Function(Content content)? onContentUpdated,
      Function()? onCancel,
      Function(String? message)? onError,
    ) => TextContentDisplay(
      noteId: noteId,
      content: con,
      form: form,
      position: position,
      onContentUpdated: onContentUpdated,
      onCancel: onCancel,
      onError: onError,
    ),
  );

  static final image = Types._build(
    name: 'Image', 
    icon: const Icon(Icons.image_rounded), 
    display: (
      String noteId,
      Content? con,
      bool form,
      int position,
      Function(Content content)? onContentUpdated,
      Function()? onCancel,
      Function(String? message)? onError,
    ) => ImageContentDisplay(
      noteId: noteId,
      content: con,
      form: form,
      position: position,
      onContentUpdated: onContentUpdated,
      onCancel: onCancel,
      onError: onError,
    ), 
  );

}