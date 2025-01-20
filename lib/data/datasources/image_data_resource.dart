
import 'dart:io';

import 'package:notes/data/datasources/interfaces.dart';
import 'package:path_provider/path_provider.dart';

class ImageFileDataSourceImpl implements ImageFileDataSource {

  @override
  Future<String> saveImage(File image) async {
    final String directory = (await getApplicationDocumentsDirectory()).path;
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final String imagePath = '$directory/$fileName';
    await image.copy(imagePath);
    return fileName;
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
  Future<String?> substituteImage(String fileName, String path) async {
    final bool deleted = await deleteImage(fileName);
    if (!deleted) return null;
    return await saveImage(File(path));
  }
  
  @override
  Future<File?> getImage(String fileName) async {
    final String directory = (await getApplicationDocumentsDirectory()).path;
    final String imagePath = '$directory/$fileName';
    final imageFile = File(imagePath);
    return (await imageFile.exists()) ? imageFile : null;
  }
  
}