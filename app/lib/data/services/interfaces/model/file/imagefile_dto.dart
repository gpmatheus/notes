
import 'dart:typed_data';

class ImagefileDto {

  ImagefileDto({
    required this.imageFileName, 
    required this.bytes,
  });

  final String imageFileName;
  final Uint8List bytes;
}