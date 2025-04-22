
import 'dart:io';
import 'dart:typed_data';

import 'package:notes/data/services/interfaces/image_file_service_interface.dart';
import 'package:notes/data/services/interfaces/model/exceptions/not_found_exception.dart';
import 'package:notes/data/services/interfaces/model/file/imagefile_dto.dart';
import 'package:path_provider/path_provider.dart';

class ImageFileService implements ImageFileServiceInterface {

  @override
  Future<ImagefileDto> saveImage(ImagefileDto image) async {
    final String directory = (await getApplicationDocumentsDirectory()).path;
    final String imagePath = '$directory/${image.imageFileName}';
    final File newFile = await File(imagePath).writeAsBytes(image.bytes);
    return ImagefileDto(
      imageFileName: image.imageFileName, 
      bytes: await newFile.readAsBytes(),
    );
  }
  
  @override
  Future<bool> deleteImage(String fileName) async {
    final String directory = (await getApplicationDocumentsDirectory()).path;
    final String imagePath = '$directory/$fileName';
    final File imageFile = File(imagePath);
    if (await imageFile.exists()) {
      await imageFile.delete(recursive: false);
      return true;
    }
    return false;
  }
  
  @override
  Future<ImagefileDto> substituteImage(String fileName, ImagefileDto newImage) async {
    final bool deleted = await deleteImage(fileName);
    if (!deleted) return throw Exception('Image could not be deleted');
    return await saveImage(newImage);
  }
  
  @override
  Future<Uint8List> getImage(String fileName) async {
    final String directory = (await getApplicationDocumentsDirectory()).path;
    final String imagePath = '$directory/$fileName';
    final imageFile = File(imagePath);
    if (!(await imageFile.exists())) throw NotFoundException('Image could not be found');
    Uint8List? imageBytes = await imageFile.readAsBytes();
    return imageBytes;
  }
}