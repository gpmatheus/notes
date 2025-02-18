
import 'package:flutter/foundation.dart';
import 'package:notes/data/repository/interfaces/text_content_repository_interface.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/content/text_content/text_content.dart';

class TextFormViewmodel extends ChangeNotifier {

  TextFormViewmodel({
    required String noteId,
    required TextContentRepositoryInterface textRepository,
    required List<Content> contents,
    TextContent? content,
  }) : 
  _noteId = noteId,
  _textRepository = textRepository,
  _content = content,
  _contents = contents;

  final String _noteId;
  final TextContentRepositoryInterface _textRepository;
  final TextContent? _content;
  final List<Content> _contents;

  TextContent? get content => _content;
  List<Content> get contents => _contents;

  Future<Content?> send(String text) {
    if (_content == null) {
      return _textRepository.createContent(
        noteId: _noteId, 
        text: text, 
        position: contents.length
      );
    }

    return _textRepository.updateContent(
      contentId: _content.id, 
      noteId: _noteId, 
      text: text, 
      position: _content.position,
    );
  }

}