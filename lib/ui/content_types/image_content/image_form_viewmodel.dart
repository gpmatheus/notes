
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/data/repository/interfaces/image_content_repository_interface.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/content/image_content/image_content.dart';

class ImageFormViewmodel extends ChangeNotifier {

  ImageFormViewmodel({
    required String noteId,
    required ImageContentRepositoryInterface imageRepository,
    required ImageContent? content,
    required List<Content> contents,
  }) :
    _noteId = noteId,
    _imageRepository = imageRepository,
    _content = content,
    _contents = contents;

  final String _noteId;
  final ImageContentRepositoryInterface _imageRepository;
  final ImageContent? _content;
  final List<Content> _contents;
  File? _image;

  ImageContent? get content => _content;
  List<Content> get contents => _contents;
  File? get image => _image;

  Future<void> setImage(File? image) async {
    if (image == null) {
      _image = null;
      notifyListeners();
      return;
    }
    final bool exists = await image.exists();
    if (exists) {
      _image = image;
      notifyListeners();
    }
  }

  Future<Content?> send() async {
    if (_image == null) return null;
    if (_content == null) {
      return _imageRepository.createContent(
        noteId: _noteId, 
        file: _image!, 
        position: contents.length,
      );
    }

    return _imageRepository.updateContent(
      contentId: _content.id, 
      noteId: _noteId, 
      file: _image!, 
      position: _content.position,
    );
  }

}