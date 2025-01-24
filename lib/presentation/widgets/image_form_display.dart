
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:notes/domain/entities/content.dart';
import 'package:notes/presentation/widgets/content_container.dart';
import 'package:notes/presentation/widgets/content_display.dart';

class ImageFormDisplay extends StatefulWidget {
  
  const ImageFormDisplay({
    super.key, 
    this.content, 
    required this.contentsList, 
    required this.scrollController,
  });

  final Content? content;
  final List<Content> contentsList;
  final ScrollController? scrollController;

  @override
  State<StatefulWidget> createState() => _ImageFormDisplayState();

}

class _ImageFormDisplayState extends State<ImageFormDisplay> with SingleTickerProviderStateMixin {

  final ImagePicker _imagePicker = ImagePicker();
  late final ScrollController scrollController;
  ImageContent? _imageContent;

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy - HH:mm');

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController(
      initialScrollOffset: widget.scrollController != null 
        ? widget.scrollController!.offset 
        : 0.0
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Configuração da animação de transição (Slide)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Começa fora da tela (em baixo)
      end: const Offset(0.0, 0.0),   // Finaliza na posição original
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Inicia a animação
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                controller: scrollController,
                shrinkWrap: true,
                itemCount: widget.contentsList.length,
                itemBuilder: (context, index) {
                  final content = widget.contentsList[index];
                  return ContentContainer(
                    content: content,
                    contentWidget: content.contentsType().displayer(widget.key, content),
                    header: content.lastEdited == null 
                      ? 'Criado em ${_dateFormat.format(content.createdAt)}'
                      : 'Editado em ${_dateFormat.format(content.lastEdited!)}'
                  );
                }
              ),
            ),
          ),
          if (_imageContent != null) ... [
            const Divider(
              height: 0.0,
              thickness: 1,
              indent: 16.0,
              endIndent: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _imageContent = null;
                          });
                        },
                        icon: Icon(
                          Icons.cancel_rounded,
                          color: Colors.red.shade300),
                      ),
                      IconButton(
                        onPressed: () {
                          _navigateBack(_imageContent!);
                        }, 
                        icon: Icon(
                          Icons.check_circle_rounded,
                          color: Theme.of(context).primaryColorLight,
                        )
                      )
                    ],
                  ),
                  ContentContainer(
                    content: _imageContent!,
                    contentWidget: ImageContentDisplay(
                      content: _imageContent!
                    )
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
            )
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => _navigateBack(null), 
                icon: const Icon(Icons.cancel_rounded)
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () => _openGallery(), 
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.photo_album_rounded, size: 40.0,),
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () => _openCamera(),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.photo_camera_back_rounded, size: 40.0,),
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateBack(Content? content) async {
    await _animationController.reverse();
    if (mounted) Navigator.pop(context, content);
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
        _imageContent = ImageContent(file: File(pickedFile.path));
      });
    }
  }
  
}