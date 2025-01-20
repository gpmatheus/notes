
import 'package:flutter/material.dart';
import 'package:notes/data/datasources/drawing_content_data_resource.dart';
import 'package:notes/data/datasources/image_contents_data_resource.dart';
import 'package:notes/data/datasources/interfaces.dart';
import 'package:notes/data/datasources/text_contents_data_resource.dart';
import 'package:notes/domain/entities/content.dart';
import 'package:notes/presentation/widgets/content_display.dart';
import 'package:notes/presentation/widgets/image_form_display.dart';
import 'package:notes/presentation/widgets/text_form_display.dart';

class ContentsType {

  const ContentsType._build({
    required this.displayer,
    required this.localDataResource,
    required this.remoteDataResource,
    required this.icon,
    required this.name,
    required this.form,
  });

  static final all = [
    text,
    image,
    // drawing,
  ];

  static final ContentsType text = ContentsType._build(
    displayer: (Key? key, Content content) {
      return TextContentDisplay(key: key, content: content) as Widget;
    },
    localDataResource: TextContentDataResource(),
    remoteDataResource: null,
    icon: const Icon(Icons.text_fields_rounded),
    name: 'Text',
    form : (
      Key? key, 
      Content? content, 
      List<Content> contentsList, 
      ScrollController scrollController
    ) {
      return TextFormDisplay( 
        content: content,
        contentsList: contentsList, 
        scrollController: scrollController
      );
    }
  );

  static final ContentsType image = ContentsType._build(
    displayer: (Key? key, Content content) {
      return ImageContentDisplay(key: key, content: content) as Widget;
    },
    localDataResource: ImageContentDataResource(),
    remoteDataResource: null,
    icon: const Icon(Icons.image_rounded),
    name: 'Image',
    form: (
      Key? key, 
      Content? content, 
      List<Content> contentsList, 
      ScrollController scrollController
    ) {
      return ImageFormDisplay(
        content: content,
        contentsList: contentsList, 
        scrollController: scrollController
      );
    }
  );

  static final ContentsType drawing = ContentsType._build(
    displayer: (Key? key, Content content) {
      return DrawingContentDisplay(key: key, content: content) as Widget;
    },
    localDataResource: DrawingContentDataResource(),
    remoteDataResource: null,
    icon: const Icon(Icons.draw_rounded),
    name: 'Draw',
    form: (
      Key? key, 
      Content? content, 
      List<Content> contentList, 
      ScrollController scrollController
    ) {
      return const Text('desenho');
    }
  );

  final Widget Function(Key? key, Content content) displayer;
  
  final ContentDataSource localDataResource;

  final ContentDataSource? remoteDataResource;

  final Icon icon;

  final String name;

  final Widget Function(
    Key? key, 
    Content? content, 
    List<Content> contentList,
    ScrollController scrollController,
  ) form;
}