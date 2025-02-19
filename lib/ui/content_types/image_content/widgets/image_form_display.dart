
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
  late AnimationController _animationController;
  late Animation<double> _animation;
  final List<GlobalKey> _keys = [];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController(
      initialScrollOffset: widget.initialScrollPosition != null
        ? widget.initialScrollPosition!
        : 0.0
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: _animationController, 
        curve: Curves.easeInOut,
      )
    );

    final int numKeys = widget.viewModel.contents.length +
    (widget.viewModel.content == null ? 1 : 0);
    for (int i = 0; i < numKeys; i++) {
      _keys.add(GlobalKey());
    }

    final int index = widget.viewModel.content != null
    ? widget.viewModel.contents.indexOf(widget.viewModel.content! as Content)
    : widget.viewModel.contents.length;

    WidgetsBinding.instance.addPostFrameCallback((_) => _centerWidget(index));
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
            ? _getCreateContentWidget()
            : _getEditingWidget(),
          );
        }
      ),
    );
  }

  Widget _getCreateContentWidget() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: List.generate(
          widget.viewModel.contents.length + 1, 
          (index) {
            if (index < widget.viewModel.contents.length) {
              final content = widget.viewModel.contents[index];
              return ContentContainer(
                key: _keys[index],
                contentWidget: content.type.display(content), 
                content: content
              );
            }
            return _getField(context, _keys[index]);
          }
        ),
      ),
    );
  }

  Widget _getEditingWidget() {
    final int editingIndex = widget.viewModel.contents
      .indexOf((widget.viewModel.content!) as Content);
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: List.generate(
          widget.viewModel.contents.length, 
          (index) {
            if (index != editingIndex) {
              final content = widget.viewModel.contents[index];
              return ContentContainer(
                key: _keys[index],
                contentWidget: content.type.display(content), 
                content: content
              );
            }
            return _getField(context, _keys[index]);
          }
        ),
      ),
    );
  }

  Widget _getField(BuildContext context, Key key) {
    return EditingContentFrame(
      key: key,
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
        if (mounted) Navigator.pop(context, content);
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

  void _centerWidget(int index) {
    final RenderBox renderBox = _keys[index].currentContext!.findRenderObject() as RenderBox;
    final double itemHeight = renderBox.size.height;
    final double viewportHeight = MediaQuery.of(context).size.height;
    final double offset = _calculateOffset(index, itemHeight, viewportHeight);

    _animation = Tween<double>(begin: _scrollController.offset, end: offset).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward(from: 0);
    _animation.addListener(() {
      _scrollController.jumpTo(_animation.value);
    });
    _scrollController.animateTo(offset, 
      duration: const Duration(seconds: 3), 
      curve: Curves.easeInOut,
    );
  }

  double _calculateOffset(int index, double itemHeight, double viewportHeight) {
    double offset = 0;
    for (int i = 0; i < index; i++) {
      final RenderBox renderBox = _keys[i].currentContext!.findRenderObject() as RenderBox;
      offset += renderBox.size.height;
    }
    offset = offset - (viewportHeight / 2) + (itemHeight / 2);
    if (offset < 0.0) {
      offset = 0.0;
    } else if (offset > _scrollController.position.maxScrollExtent) {
      offset = _scrollController.position.maxScrollExtent;
    }
    return offset;
  }
  
}