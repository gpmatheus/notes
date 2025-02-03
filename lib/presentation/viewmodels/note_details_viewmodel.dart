
import 'package:flutter/material.dart';
import 'package:notes/domain/contents/content_types.dart';
import 'package:notes/domain/entities/content.dart';
import 'package:notes/domain/entities/note.dart';
import 'package:notes/domain/usecases/maintain_notes.dart';
import 'package:notes/domain/usecases/manage_contents.dart';

class NoteDetailsViewmodel {

  late final String _noteId;

  // estados
  final ValueNotifier<Note?> _note = ValueNotifier(null);
  final ValueNotifier<List<Content>?> _contents = ValueNotifier(null);
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<bool> _showContentCreationResult = ValueNotifier(false);
  final ValueNotifier<bool> _showContentEditionResult = ValueNotifier(false);
  final ValueNotifier<bool> _showContentDeletedResult = ValueNotifier(false);
  final ValueNotifier<NoteDetailsFields?> _fields = ValueNotifier(null);

  ResultContent? _contentCreationRes;
  ResultContent? _contentEditionRes;
  ResultContent? _contentDeletedRes;

  final ScrollController _scrollController = ScrollController();

  final MaintainNotes _maintainNotes = MaintainNotes.instance;
  final ManageContents _manageContents = ManageContents.instance;

  NoteDetailsViewmodel({Note? note, required String noteId}) {
    _noteId = noteId;

    // adiciona os Listeners nos notifiers dos estados
    _updateFields();
    _note.addListener(_updateFields);
    _contents.addListener(_updateFields);
    _loading.addListener(_updateFields);

    // busca dados registrados caso não estejam carregados ainda
    if (note == null || note.contents == null) {
      _loading.value = true;
      _maintainNotes.getNote(noteId).then((nt) {
        _note.value = nt;
        if (nt != null) _contents.value = nt.contents;
        _loading.value = false;
      });
    }
  }

  // getters
  String get noteId => _noteId;
  ValueNotifier<Note?> get note => _note;
  ValueNotifier<List<Content>?> get contents => _contents;
  ValueNotifier<bool> get loading => _loading;
  ValueNotifier<bool> get showContentCreationResult => _showContentCreationResult;
  ValueNotifier<bool> get showContentEditionResult => _showContentEditionResult;
  ValueNotifier<bool> get showContentDeletedResult => _showContentDeletedResult;
  ValueNotifier<NoteDetailsFields?> get fields => _fields;
  ResultContent? get contentCreationRes => _contentCreationRes;
  ResultContent? get contentEditionRes => _contentEditionRes;
  ResultContent? get contentDeletedRes => _contentDeletedRes;
  ScrollController? get scrollController => _scrollController;

  void deleteContent(BuildContext context, Content content, int index) async {
    _loading.value = true;
    final bool deleted = await _manageContents.deleteContent(content);

    // remove o conteúdo da lista
    if (deleted) {
      final List<Content> con = _contents.value!;
      con.removeAt(index);
      _contents.value = [...con];
    }

    _loading.value = false;
    _contentDeletedRes = ResultContent(
      success: deleted, 
      message: deleted ? 'Deleted.' : 'Content could not be deleted',
    );
    _showContentDeletedResult.value = true;
  }

  void editContent(
    BuildContext context, 
    Content content, 
    int index, 
  ) async {

    final Content? resultContent = await navigateToContentForm(
      content, 
      context, 
      content.contentsType(), 
    );

    if (resultContent != null) {
      _loading.value = true;
      final Content? editedContent = await _manageContents.editContent(resultContent.id, resultContent);

      // atualiza o conteúdo na lista
      if (editedContent != null) {
        final List<Content> con = _contents.value!;
        con[index] = editedContent;
        _contents.value = [...con];
      }

      _loading.value = false;
      _contentEditionRes = ResultContent(
        success: editedContent != null, 
        message: editedContent != null ? 'Content edited!' : 'Content could not be deleted',
      );
      _showContentEditionResult.value = true;
    }
  }

  void createContent(
    BuildContext context,
    ContentsType ct,
  ) async {

    final Content? resultContent = await navigateToContentForm(
      null, 
      context, 
      ct, 
    );

    if (resultContent != null) {
      _loading.value = true;
      final Content? createdContent = await _manageContents.createContent(noteId, resultContent);

      // adiciona o conteúdo na lista
      if (createdContent != null) {
        final List<Content> con = _contents.value!;
        con.add(createdContent);
        _contents.value = [...con];
      }

      _loading.value = false;
      _contentCreationRes = ResultContent(
        success: createdContent != null, 
        message: createdContent != null ? 'Content created!' : 'Content could not be created',
      );
      _showContentCreationResult.value = true;
    }
  }

  Future<Content?> navigateToContentForm(
    Content? content,
    BuildContext context, 
    ContentsType ct, 
  ) async {
      
    Content? resContent = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ct.form(null, content, _contents.value != null ? _contents.value! : [], scrollController);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      )
    );
    return resContent;
  }

  Future<void> switchPositions(int oldIndex, newIndex) async {
    if (_contents.value == null || _note.value == null) return;
    final backup = [..._contents.value!];
    final contents = [...backup];
    if (newIndex > oldIndex) newIndex--; 
    final item = contents.removeAt(oldIndex);
    contents.insert(newIndex, item);
    _contents.value = contents;
    bool success = await _maintainNotes.switchPositions(_note.value!.id, oldIndex, newIndex);
    if (!success) _contents.value = backup;
  }

  void _updateFields() {
    _fields.value = NoteDetailsFields(
      note: _note.value, 
      contents: _contents.value, 
      loading: _loading.value,
    );
  }
}

class NoteDetailsFields {
  NoteDetailsFields({
    required this.note, 
    required this.contents, 
    required this.loading,
  });

  final Note? note;
  final List<Content>? contents;
  final bool loading;
}

class ResultContent {
  ResultContent({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;
}