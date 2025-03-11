
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notes/config/types.dart';
import 'package:notes/data/repository/interfaces/content_repository_interface.dart';
import 'package:notes/domain/model/content/content.dart';
import 'package:notes/domain/model/note/note.dart';
import 'package:notes/domain/usecases/maintain_notes.dart';
import 'package:notes/domain/usecases/manage_contents.dart';
import 'package:notes/ui/note_form/note_form_viewmodel.dart';
import 'package:notes/ui/note_form/widgets/note_form.dart';
import 'package:notes/utils/formatted_logger.dart';
import 'package:provider/provider.dart';

class NoteDetailsViewmodel extends ChangeNotifier {

  // estados
  Note? _note;
  bool _loading = false;
  int _selectedContentIndex = -1;
  bool _hasChanged = false;

  // modal
  bool _showModal = false;
  String? _modalMessage;
  bool _modalSuccess = false;

  // form
  int _formIndex = -1;
  Types? _type;

  final ManageContents _contentUseCase;
  final MaintainNotes _maintainNotes;
  final ContentRepositoryInterface _contentRepository;

  // logger
  final Logger _logger = FormattedLogger.instance;

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
  int get selectedContentIndex => _selectedContentIndex;
  bool get showModal => _showModal;
  String? get modalMessage => _modalMessage;
  bool get modalSuccess => _modalSuccess;
  int get formIndex => _formIndex;
  Types? get formType => _type;
  bool get hasChanged => _hasChanged;


  void deleteContent(int index) async {
    if (index < 0 || index >= note!.contents!.length) return;
    final Content content = note!.contents![index];
    _turnLoadingOn();
    final bool deleted = await _contentUseCase.deleteContent(content.id);
    _turnLoadingOff();

    _modalMessage = deleted ? 'Content deleted.' : 'Content could not be deleted';
    _modalSuccess = deleted;
    _showModal = true;
    _formIndex = -1;
    _selectedContentIndex = -1;
    notifyListeners();
    _showModal = false;
    if (deleted) {
      _loadNote(_note!.id);
    }
  }

  void closeModal() {
    _logger.d('closing modal');
    _showModal = false;
    notifyListeners();
  }

  void selectContent(int index) async {
    _logger.d('Selected content of index $index');
    if (note == null || note!.contents == null || index >= note!.contents!.length) return;
    _selectedContentIndex = index;
    notifyListeners();
  }

  void editContent(int index) async {
    _logger.d('Setting content editing in index $index');
    if (_type != null) return;
    _selectedContentIndex = -1;
    _formIndex = index;
    notifyListeners();
  }

  // this method should not be async because the floating action button gets slowed in animation
  void newContentForm(Types type) {
    _logger.d('Adding new content form of type ${type.name}');
    if (_note == null) return;
    _type = type;
    _selectedContentIndex = -1;
    _formIndex = note!.contents!.length;
    notifyListeners();
  }

  Future<void> switchPositions(int oldIndex, newIndex) async {
    _logger.d('Switching position $oldIndex for $newIndex');
    if (_note == null || _note!.contents == null) return;

    Content? oldIndexContent = _note!.contents![oldIndex];
    Content? newIndexContent = _note!.contents![newIndex];

    // switch positions in the note contents list
    _note!.contents![oldIndex] = newIndexContent.changePosition(oldIndex);
    _note!.contents![newIndex] = oldIndexContent.changePosition(newIndex);
    notifyListeners();

    final bool success = await _contentRepository
      .switchPositions(_note!.id, oldIndexContent, newIndexContent);

    _logger.d(success ? 'Positions switched' : 'Positions could not be switched');
    
    if (!success) {
      await _loadNoteUnderHood(_note!.id);
      notifyListeners();
    }
  }

  Future<bool> deleteNote() async {
    if (_note != null) return _maintainNotes.deleteNote(_note!.id);
    return false;
  }

  void navigateToNoteForm(BuildContext context) async {
    Note? updatedNote = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: NoteForm(
              viewModel: NoteFormViewmodel(
                maintainNotes: context.read(),
                note: _note!,
              ),
            ),
          );
        }
      )
    );
    if (updatedNote != null) {
      _hasChanged = true;
      _loadNote(updatedNote.id);
    }
  }

  void onContentUpdated(Content? content) async {
    _logger.d('Handling content update action.\n${content.toString()}');
    // check if the "updated content" is an actual update 
    // or the creation of a new content
    final bool success = content != null;
    if (_type == null) {
      // was an actual update
      _modalMessage = success ? 'Content updated' : 'Content could not be updated';
      _modalSuccess = success;
      _showModal = true;
      if (success) {
        final int position = content.position;
        _note!.contents![position] = content;
      }
    } else {
      // was the creation of a content
      _modalMessage = success ? 'Content created' : 'Content could not be created';
      _modalSuccess = success;
      _showModal = true;
      if (success) {
        _note!.contents!.add(content);
      }
    }
    _formIndex = -1;
    _selectedContentIndex = -1;
    _type = null;
    notifyListeners();
    _showModal = false;
    notifyListeners();

    // this part is for reloading the whole note again, but for performance reasons
    // I think the note contents list should be updated in the front end
    // so this section will be commented
    // await _loadNoteUnderHood(_note!.id);
    // notifyListeners();
  }

  void onCancel() async {
    _logger.d('Handling cancel action');
    _formIndex = -1;
    _selectedContentIndex = -1;
    _type = null;
    notifyListeners();
  }

  void onError(String? message) async {
    _logger.d('Showing error message');
    _modalMessage = 'Something went wrong';
    _modalSuccess = false;
    _showModal = true;
    notifyListeners();
    _showModal = false;
  }

  Future<void> _loadNote(String noteId) async {
    _turnLoadingOn();
    await _loadNoteUnderHood(noteId);
    _turnLoadingOff();
  }

  Future<void> _loadNoteUnderHood(String noteId) async {
    _logger.d('Loading note');
    _note = await _maintainNotes.getNote(noteId);
    _logger.d('Loaded note: ${_note != null ? _note.toString() : _note}');
  }

  void _turnLoadingOn() {
    _logger.d('Showing loading signal');
    _loading = true;
    notifyListeners();
  }

  void _turnLoadingOff() {
    _logger.d('Hiding loading signal');
    _loading = false;
    notifyListeners();
  }
}