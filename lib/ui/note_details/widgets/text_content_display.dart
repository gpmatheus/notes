
import 'package:flutter/material.dart';
import 'package:notes/data/repository/implementations/text_content_repository.dart';
import 'package:notes/data/repository/interfaces/text_content_repository_interface.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/content/text_content/text_content.dart';
import 'package:notes/ui/core/editing_content_frame.dart';
import 'package:provider/provider.dart';

class TextContentDisplay extends StatefulWidget {

  final String noteId;
  final TextContent? content;
  final bool form;
  final int position;
  final Function(Content content)? onContentUpdated;
  final Function()? onCancel;
  final Function(String? message)? onError;

  const TextContentDisplay({
    super.key, 
    required this.noteId,
    Content? content,
    required this.form,
    required this.position,
    this.onContentUpdated,
    this.onCancel,
    this.onError,
  }) : 
    content = content as TextContent?;

  @override
  State<StatefulWidget> createState() => _TextContentDisplayState();
}

class _TextContentDisplayState extends State<TextContentDisplay> {

  TextContentRepositoryInterface get _textContentRepository => 
    Provider.of<TextContentRepository>(context, listen: false);

  final TextEditingController _textController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    
    _textController.text = widget.content != null 
      ? widget.content!.text 
      : '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.form
            ? EditingContentFrame(
                loading: _loading,
                content: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: 9,
                  minLines: 1,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ), 
                cancel: _cancel,
                send: _send,
              )
            : Text(widget.content != null ? widget.content!.text : ''),
        )
      ),
    );
  }

  void _cancel() {
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
  }

  void _send() {
    setState(() {
      _loading = true;
    });
    if (widget.content != null) {
      _textContentRepository.updateContent(
        noteId: widget.noteId, 
        contentId: widget.content!.id, 
        text: _textController.text,
      ).then(_then)
      .catchError(_catchError)
      .whenComplete(_whenComplete);
    } else {
      _textContentRepository.createContent(
        noteId: widget.noteId,
        text: _textController.text,
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
}