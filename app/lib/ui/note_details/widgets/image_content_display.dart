
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/data/repository/implementations/image_content_repository.dart';
import 'package:notes/data/repository/interfaces/image_content_repository_interface.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/content/image_content/image_content.dart';
import 'package:notes/ui/core/editing_content_frame.dart';
import 'package:provider/provider.dart';

class ImageContentDisplay extends StatefulWidget {

  final String noteId;
  final ImageContent? content;
  final bool form;
  final int position;
  final Function(Content content)? onContentUpdated;
  final Function()? onCancel;
  final Function(String? message)? onError;

  const ImageContentDisplay({
    super.key, 
    required this.noteId,
    Content? content,
    required this.form,
    required this.position,
    this.onContentUpdated,
    this.onCancel,
    this.onError,
  }) : 
    content = content as ImageContent?;

  @override
  State<StatefulWidget> createState() => _ImageContentDisplayState();
}

class _ImageContentDisplayState extends State<ImageContentDisplay> {
  
  ImageContentRepositoryInterface get _imageContentRepository =>
    Provider.of<ImageContentRepository>(context, listen: false);
  
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    if (widget.content != null && widget.content!.file != null) {
      _image = widget.content!.file;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.form
          ?  EditingContentFrame(
              loading: _loading,
              content: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: _openCamera, 
                        icon: const Icon(Icons.photo_camera_rounded)
                      ),
                      IconButton(
                        onPressed: _openGallery, 
                        icon: const Icon(Icons.image_rounded)
                      ),
                    ],
                  ),
                  if (_image != null) ... {
                    Image.file(_image!)
                  }
                ],
              ), 
              cancel: _cancel, 
              send: _send,
            )
          : widget.content != null && widget.content!.file != null 
            ? Image.file(widget.content!.file!) 
            : const Text('No image')
        ),
      ),
    );
  }

  void _cancel() {
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
  }

  void _send() {
    if (_image == null) return;
    setState(() {
      _loading = true;
    });
    if (widget.content != null) {
      _imageContentRepository.updateContent(
        noteId: widget.noteId, 
        contentId: widget.content!.id, 
        file: _image!,
      ).then(_then)
      .catchError(_catchError)
      .whenComplete(_whenComplete);
    } else {
      _imageContentRepository.createContent(
        noteId: widget.noteId,
        file: _image!,
        position: widget.position,
      ).then(_then)
      .catchError(_catchError)
      .whenComplete(_whenComplete);
    }
  }

  void _then(Content? content) {
    if (widget.onContentUpdated != null && content != null) {
      widget.onContentUpdated!(content);
    }
  }

  void _catchError(dynamic error) {
    if (widget.onError != null) {
      widget.onError!(error.toString());
    }
  }

  void _whenComplete() {
    setState(() {
      _loading = false;
    });
  }

  Future<void> _openCamera() async {
    await _pickImage(ImageSource.camera);
  }

  Future<void> _openGallery() async {
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _pickImage(ImageSource imgSrc) async {

    final pickedFile = await _imagePicker.pickImage(
      source: imgSrc,
      maxHeight: 500
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}