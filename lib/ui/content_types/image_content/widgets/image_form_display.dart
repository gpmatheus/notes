
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/ui/content_types/image_content/image_form_viewmodel.dart';
import 'package:notes/ui/core/content_container.dart';
import 'package:notes/ui/core/editing_content_frame.dart';

class ImageFormDisplay extends StatefulWidget {
  
  const ImageFormDisplay({
    super.key, 
    this.initialScrollPosition,
    required this.viewModel,
  });

  final ImageFormViewmodel viewModel;
  final double? initialScrollPosition;

  @override
  State<StatefulWidget> createState() => _ImageFormDisplayState();

}

class _ImageFormDisplayState extends State<ImageFormDisplay> with SingleTickerProviderStateMixin {

  final ImagePicker _imagePicker = ImagePicker();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController(
      initialScrollOffset: widget.initialScrollPosition
        != null
        ? widget.initialScrollPosition!
        : 0.0
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.viewModel.content != null ? 'Edit' : 'Add'} image'),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.viewModel.content == null
            ? _getCreateContentWidget(context)
            : _getEditingWidget(context),
          );
        }
      ),
    );
  }

  Widget _getCreateContentWidget(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: widget.viewModel.contents.length + 1,
      itemBuilder: (context, index) {
        if (index < widget.viewModel.contents.length) {
          final content = widget.viewModel.contents[index];
          return ContentContainer(
            contentWidget: content.type.display(content), 
            content: content
          );
        }
        return _getField(context);
      },
    );
  }

  Widget _getEditingWidget(BuildContext context) {
    final int editingIndex = widget.viewModel.contents
      .indexOf((widget.viewModel.content!) as Content);
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: widget.viewModel.contents.length,
      itemBuilder: (context, index) {
        if (index != editingIndex) {
          final content = widget.viewModel.contents[index];
          return ContentContainer(
            contentWidget: content.type.display(content), 
            content: content
          );
        }
        return _getField(context);
      }
    );
  }

  Widget _getField(BuildContext context) {
    return EditingContentFrame(
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
          if (widget.viewModel.image != null) ... {
            Image.file(widget.viewModel.image!)
          }
        ],
      ), 
      cancel: () => Navigator.pop(context), 
      send: () async { 
        Content? content = await widget.viewModel.send();
        // ignore: use_build_context_synchronously
        if (content != null) Navigator.pop(context, content);
      },
    );  
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
      widget.viewModel.setImage(File(pickedFile.path));
    }
  }
  
}