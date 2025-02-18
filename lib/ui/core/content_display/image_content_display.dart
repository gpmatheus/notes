

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/content/image_content/image_content.dart';

class ImageContentDisplay extends StatelessWidget {

  final File? imageFile;

  ImageContentDisplay({super.key, required Content content}) : 
    imageFile = (content as ImageContent).file;

  @override
  Widget build(BuildContext context) {
    return imageFile != null 
    ? Image.file(imageFile!) 
    : const Text('No image');
  }
  
}