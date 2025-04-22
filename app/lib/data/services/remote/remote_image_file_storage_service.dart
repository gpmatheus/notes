
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'package:notes/data/services/interfaces/image_file_service_interface.dart';
import 'package:notes/data/services/interfaces/model/file/imagefile_dto.dart';

class RemoteImageFileStorageService implements ImageFileServiceInterface {

  // final String _filesEndpoint = 'http://localhost:8080/files/';
  final String _downloadEndpoint = 'http://localhost:8080/files/download/';
  final String _uploadEndpoint = 'http://localhost:8080/files/upload';
  final String _deleteEndpoint = 'http://localhost:8080/files/delete/';
  
  @override
  Future<bool> deleteImage(String fileName) {
    return http.delete(Uri.parse('$_deleteEndpoint$fileName')).then((http.Response response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete image');
      }
    });
  }

  @override
  Future<Uint8List> getImage(String fileName) async {
    final http.Response response = await http.get(Uri.parse('$_downloadEndpoint$fileName'));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Future<ImagefileDto> saveImage(ImagefileDto image) async {
    final http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(_uploadEndpoint));
    final http.MultipartFile file = http.MultipartFile.fromBytes(
      "file", 
      image.bytes,
      filename: image.imageFileName,
    );
    request.files.add(file);

    final http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return ImagefileDto(
        imageFileName: image.imageFileName, 
        bytes: image.bytes
      );
    } else {
      throw Exception('Failed to upload image');
    }
  }

  @override
  Future<ImagefileDto> substituteImage(String fileName, ImagefileDto newImage) async {
    await deleteImage(fileName);
    return saveImage(newImage);
  }

}