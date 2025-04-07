
import 'dart:io';

import 'package:notes/data/services/interfaces/image_file_service_interface.dart';
import 'package:notes/data/services/interfaces/model/file/imagefile_dto.dart';

class RemoteImageFileStorageService implements ImageFileServiceInterface {

  
  @override
  Future<bool> deleteImage(String fileName) {
    // TODO: implement deleteImage
    throw UnimplementedError();
  }

  @override
  Future<File?> getImage(String fileName) {
    // TODO: implement getImage
    throw UnimplementedError();
  }

  @override
  Future<ImagefileDto?> saveImage(File image) {
    // TODO: implement saveImage
    throw UnimplementedError();
  }

  @override
  Future<ImagefileDto?> substituteImage(String fileName, String path) {
    // TODO: implement substituteImage
    throw UnimplementedError();
  }

}