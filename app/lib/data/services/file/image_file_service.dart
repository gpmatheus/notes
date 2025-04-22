
// import 'dart:io';

// import 'package:notes/data/services/interfaces/image_file_service_interface.dart';
// import 'package:notes/data/services/interfaces/model/file/imagefile_dto.dart';
// import 'package:path_provider/path_provider.dart';

// class ImageFileService implements ImageFileServiceInterface {

//   @override
//   Future<ImagefileDto?> saveImage(File image) async {
//     final String directory = (await getApplicationDocumentsDirectory()).path;
//     final String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
//     final String imagePath = '$directory/$fileName';
//     final File newFile = await image.copy(imagePath);
//     return ImagefileDto(
//       imageFileName: fileName, 
//       file: newFile,
//     );
//   }
  
//   @override
//   Future<bool> deleteImage(String fileName) async {
//     final String directory = (await getApplicationDocumentsDirectory()).path;
//     final String imagePath = '$directory/$fileName';
//     final File imageFile = File(imagePath);
//     if (await imageFile.exists()) {
//       await imageFile.delete(recursive: false);
//       return true;
//     }
//     return false;
//   }
  
//   @override
//   Future<ImagefileDto?> substituteImage(String fileName, String path) async {
//     final bool deleted = await deleteImage(fileName);
//     if (!deleted) return null;
//     return await saveImage(File(path));
//   }
  
//   @override
//   Future<File?> getImage(String fileName) async {
//     final String directory = (await getApplicationDocumentsDirectory()).path;
//     final String imagePath = '$directory/$fileName';
//     final imageFile = File(imagePath);
//     return (await imageFile.exists()) ? imageFile : null;
//   }
// }