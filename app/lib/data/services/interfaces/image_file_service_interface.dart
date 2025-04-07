
import 'dart:io';

import 'package:notes/data/services/interfaces/model/file/imagefile_dto.dart';

abstract class ImageFileServiceInterface {

  Future<ImagefileDto?> saveImage(File image);
  Future<bool> deleteImage(String fileName);
  Future<ImagefileDto?> substituteImage(String fileName, String path);
  Future<File?> getImage(String fileName);
}