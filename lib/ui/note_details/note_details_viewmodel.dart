
import 'package:flutter/material.dart';
import 'package:notes/data/repository/interfaces/content_repository_interface.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/note/note.dart';
import 'package:notes/domain/usecases/maintain_notes.dart';
import 'package:notes/domain/usecases/manage_contents.dart';

class NoteDetailsViewmodel extends ChangeNotifier {

  // estados
  Note? _note;
  bool _loading = false;
  bool _showContentDeletedResult = false;
  bool _deletedSuccess = false;

  final ManageContents _contentUseCase;
  final MaintainNotes _maintainNotes;
  final ContentRepositoryInterface _contentRepository;

  NoteDetailsViewmodel({
    required String noteId,
    required ManageContents contentUseCase,
    required MaintainNotes maintainNotes,
    required ContentRepositoryInterface contentRepository
  }) :
    _contentUseCase = contentUseCase,
    _contentRepository = contentRepository,
    _maintainNotes = maintainNotes {
    _loadNote(noteId);
  }

  // getters
  Note? get note => _note;
  bool get loading => _loading;
  bool get showContentDeletedResult => _showContentDeletedResult;
  bool get deletedSuccess => _deletedSuccess;

  void hideContentDeletionResult() {
    _showContentDeletedResult = false;
    notifyListeners();
  }


  void deleteContent(BuildContext context, Content content, int index) async {
    _turnLoadingOn();
    final bool deleted = await _contentUseCase.deleteContent(content.id);
    _turnLoadingOff();

    _deletedSuccess = deleted;
    _showContentDeletedResult = true;
    notifyListeners();
    if (deleted) {
      _loadNote(_note!.id);
    }
  }

  // void editContent(
  //   BuildContext context, 
  //   Content content, 
  //   int index, 
  // ) async {

  //   final Content? resultContent = await navigateToContentForm(
  //     content, 
  //     context, 
  //     content.contentsType(), 
  //   );

  //   if (resultContent != null) {
  //     _loading.value = true;
  //     final Content? editedContent = await _manageContents.editContent(resultContent.id, resultContent);

  //     // atualiza o conteúdo na lista
  //     if (editedContent != null) {
  //       final List<Content> con = _contents.value!;
  //       con[index] = editedContent;
  //       _contents.value = [...con];
  //     }

  //     _loading.value = false;
  //     _contentEditionRes = ResultContent(
  //       success: editedContent != null, 
  //       message: editedContent != null ? 'Content edited!' : 'Content could not be deleted',
  //     );
  //     _showContentEditionResult.value = true;
  //   }
  // }

  // void createContent(
  //   BuildContext context,
  //   ContentsType ct,
  // ) async {

  //   final Content? resultContent = await navigateToContentForm(
  //     null, 
  //     context, 
  //     ct, 
  //   );

  //   if (resultContent != null) {
  //     _loading.value = true;
  //     final Content? createdContent = await _manageContents.createContent(noteId, resultContent);

  //     // adiciona o conteúdo na lista
  //     if (createdContent != null) {
  //       final List<Content> con = _contents.value!;
  //       con.add(createdContent);
  //       _contents.value = [...con];
  //     }

  //     _loading.value = false;
  //     _contentCreationRes = ResultContent(
  //       success: createdContent != null, 
  //       message: createdContent != null ? 'Content created!' : 'Content could not be created',
  //     );
  //     _showContentCreationResult.value = true;
  //   }
  // }


  // TODO
  Future<Content?> navigateToContentForm({
    Content? content,
    required BuildContext context, 
    required Widget form, 
  }) async {
      
    Content? resContent = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return form;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      )
    );
    await _loadNote(_note!.id);
    return resContent;
  }

  Future<void> switchPositions(int oldIndex, newIndex) async {
    if (_note == null || _note!.contents == null) return;
    Content? oldIndexContent = _note!.contents!.singleWhere((con) => con.position == oldIndex);
    Content? newIndexContent = _note!.contents!.singleWhere((con) => con.position == newIndex);
    final bool succcess = await _contentRepository
      .switchPositions(_note!.id, oldIndexContent, newIndexContent);
    if (succcess) _loadNote(_note!.id);
  }

  Future<void> _loadNote(String noteId) async {
    _turnLoadingOn();
    Note? note = await _maintainNotes.getNote(noteId);
    _note = note;
    _turnLoadingOff();
  }

  void _turnLoadingOn() {
    _loading = true;
    notifyListeners();
  }

  void _turnLoadingOff() {
    _loading = false;
    notifyListeners();
  }
}