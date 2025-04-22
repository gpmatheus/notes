
import 'dart:typed_data';

import 'package:notes/data/services/interfaces/model/file/imagefile_dto.dart';

abstract class ImageFileServiceInterface {

  /// Saves the image file
  /// 
  /// Throws [Exception] if the image file cannot be saved.
  /// Returns the saved [ImagefileDto] object.
  ///
  Future<ImagefileDto> saveImage(ImagefileDto image);

  /// Deletes the image file
  ///
  /// Throws [Exception] if the image file cannot be deleted.
  /// Returns true if the image file was deleted successfully, false otherwise.
  ///
  Future<bool> deleteImage(String fileName);

  /// Substitutes the image file with a new one
  ///
  /// Throws [Exception] if the image file cannot be substituted.
  /// Returns the substituted [ImagefileDto] object.
  ///
  /// [fileName] is the name of the image file to be substituted.
  /// [newImage] is the new image file to be saved.
  ///
  /// This method first deletes the existing image file and then saves the new image file.
  /// If the existing image file cannot be deleted, an exception is thrown.
  /// If the new image file cannot be saved, an exception is thrown.
  ///
  Future<ImagefileDto> substituteImage(String fileName, ImagefileDto newImage);

  /// Retrieves the image file
  ///
  /// Throws [Exception] if the image file cannot be retrieved.
  /// Returns the image file as a [Uint8List].
  ///
  /// [fileName] is the name of the image file to be retrieved.
  Future<Uint8List> getImage(String fileName);
}