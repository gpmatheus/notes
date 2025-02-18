
import 'package:flutter/material.dart';
import 'package:notes/data/repository/implementations/image_content_repository.dart';
import 'package:notes/data/repository/implementations/text_content_repository.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/content/image_content/image_content.dart';
import 'package:notes/domain/model/content/text_content/text_content.dart';
import 'package:notes/ui/content_types/image_content/image_form_viewmodel.dart';
import 'package:notes/ui/content_types/image_content/widgets/image_form_display.dart';
import 'package:notes/ui/content_types/text_content/text_form_viewmodel.dart';
import 'package:notes/ui/content_types/text_content/widgets/text_form_display.dart';
import 'package:notes/ui/core/content_display/image_content_display.dart';
import 'package:notes/ui/core/content_display/text_content_display.dart';
import 'package:provider/provider.dart';

class Types {

  final String name;
  final Widget icon;
  final Widget Function(
    BuildContext context,
    Content? con, 
    double? initialScrollPosition, 
    List<Content> contents,
    String noteId) form;
  final Widget Function(Content con) display;

  const Types._build({
    required this.name, 
    required this.icon, 
    required this.form, 
    required this.display,
  });

  static final all = [
    text,
    image,
  ];

  static final text = Types._build(
    name: 'Text', 
    icon: const Icon(Icons.text_fields_rounded), 
    form: (
      BuildContext context,
      Content? con, 
      double? initialScrollPosition, 
      List<Content> contents,
      String noteId) {
      return TextFormDisplay(
        initialScrollPosition: initialScrollPosition,
        viewModel: TextFormViewmodel(
          contents: contents,
          content: con as TextContent?, 
          noteId: noteId, 
          textRepository: context.read<TextContentRepository>(),
        ),
      );
    }, 
    display: (Content con) => TextContentDisplay(content: con),
  );

  static final image = Types._build(
    name: 'Image', 
    icon: const Icon(Icons.image_rounded), 
    form: (
      BuildContext context,
      Content? con, 
      double? initialScrollPosition, 
      List<Content> contents,
      String noteId) => ImageFormDisplay(
        initialScrollPosition: initialScrollPosition, 
        viewModel: ImageFormViewmodel(
          noteId: noteId, 
          imageRepository: context.read<ImageContentRepository>(), 
          content: con as ImageContent?, 
          contents: contents
        ),
      ),
    display: (Content con) => ImageContentDisplay(content: con), 
  );

}