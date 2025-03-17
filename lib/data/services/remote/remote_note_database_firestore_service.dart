
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/data/services/interfaces/note_service.dart';
import 'package:notes/data/services/interfaces/model/exceptions/invalid_input_exception.dart';
import 'package:notes/data/services/interfaces/model/exceptions/not_found_exception.dart';
import 'package:notes/data/services/interfaces/model/note/note_dto.dart';

class RemoteNoteDatabaseFirestoreService implements NoteService {

  final FirebaseFirestore _firestore;
  late final CollectionReference _noteRef;

  RemoteNoteDatabaseFirestoreService({
    required FirebaseFirestore firestore,
  }) :
    _firestore = firestore {
      _noteRef = _firestore.collection('notes').withConverter<NoteDto>(
        fromFirestore: (snapshot, _) => NoteDto.fromJson({'id': snapshot.id, ...snapshot.data()!}), 
        toFirestore: (note, _) {
          Map<String, Object?> json = note.toJson();
          json.remove('id');
          return json;
        },
      );
    }

  @override
  Future<NoteDto?> createNote(NoteDto noteDto) async {
    if (noteDto.id.isEmpty) throw InvalidInputException('Note with id of ${noteDto.id} is not valid');
    if (await _noteExists(noteDto.id)) {
      throw InvalidInputException('Note with id ${noteDto.id} already exists.');
    }
    await _noteRef.doc(noteDto.id).set(noteDto);
    return noteDto;
  }

  @override
  Future<void> deleteNote(String noteId) async {
    if (!(await _noteExists(noteId))) {
      throw NotFoundException('Note could not be found');
    }
    _noteRef.doc(noteId).delete();
  }

  @override
  Future<NoteDto?> getNoteById(String noteId) async {
    return await _noteRef.doc(noteId).get().then((snapshot) => snapshot.data() as NoteDto?);
  }

  @override
  Future<List<NoteDto>> getNotes() async {
    return (await _noteRef.get()).docs.map((doc) => doc.data() as NoteDto).toList();
  }

  @override
  Future<NoteDto?> updateNote(String id, NoteDto noteDto) async {
    if (!(await _noteExists(id))) throw NotFoundException('Note could not be found');

    await _noteRef.doc(noteDto.id).set(noteDto);
    return noteDto;
  }

  Future<bool> _noteExists(String noteId) async {
    return (await _firestore.collection('notes').doc(noteId).get()).exists;
  }

}
