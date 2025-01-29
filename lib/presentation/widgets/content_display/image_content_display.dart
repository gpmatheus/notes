

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/domain/entities/content.dart';

class ImageContentDisplay extends StatelessWidget {

  final File imageFile;

  ImageContentDisplay({super.key, required Content content}) : 
    imageFile = (content as ImageContent).file;

  @override
  Widget build(BuildContext context) {
    return Image.file(imageFile);
  }
  
}