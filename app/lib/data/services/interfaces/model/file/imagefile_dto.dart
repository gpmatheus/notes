
import 'dart:io';

class ImagefileDto {

  ImagefileDto({
    required this.imageFileName, 
    required this.file,
  });

  final String imageFileName;
  final File file;
}