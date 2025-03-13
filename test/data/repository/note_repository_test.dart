
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:notes/data/repository/implementations/note_repository.dart';
import 'package:notes/data/repository/interfaces/note_repository_interface.dart';
import 'package:notes/data/services/local/interfaces/local_content_type_service.dart';
import 'package:notes/data/services/local/interfaces/local_note_service.dart';
import 'package:notes/data/services/local/interfaces/model/note/note_dto.dart';
import 'package:notes/domain/model/note/note.dart';

import 'note_repository_test.mocks.dart';

@GenerateMocks([LocalNoteService])
void main() {

  late NoteRepositoryInterface repository;
  late MockLocalNoteService noteService;
  late List<LocalContentTypeService> contentServices;

  group('Test NoteRepository implements NoteRepositoryInterface', () {
    group('test the insertNote method', () {

      setUp(() {
        noteService = MockLocalNoteService();
        contentServices = [];
        repository = NoteRepository(
          localNoteService: noteService,
          localContentServices: contentServices,
        );
      });

      test('should return a Note when the note is inserted', () async {
        // Arrange
        const noteName = 'Note name';
        const noteId = 'noteId';
        final noteDto = NoteDto(
          id: noteId,
          name: noteName,
          createdAt: DateTime.now(),
          lastEdited: null,
        );
        when(noteService.createNote(any)).thenAnswer((_) async => noteDto);
        // Act
        final result = await repository.insertNote(noteName);
        // Assert
        expect(result, isNotNull);
        expect(result!.id, noteId);
      });

      test('should return null when the note is not inserted', () async {
        // Arrange
        const noteName = 'Note name';
        when(noteService.createNote(any)).thenAnswer((_) async => null);
        // Act
        final result = await repository.insertNote(noteName);
        // Assert
        expect(result, null);
      });
    });

    group('test the updateNote method', () {
      
      setUp(() {
        noteService = MockLocalNoteService();
        contentServices = [];
        repository = NoteRepository(
          localNoteService: noteService,
          localContentServices: contentServices,
        );
      });

      test('should return a Note when the note is updated', () async {
        // Arrange
        const noteId = 'noteId';
        final noteDto = NoteDto(
          id: noteId,
          name: 'Note name',
          createdAt: DateTime.now(),
          lastEdited: null,
        );
        when(noteService.getNoteById(noteId)).thenAnswer((_) async => noteDto);
        when(noteService.updateNote(noteId, any)).thenAnswer((_) async => noteDto);
        // Act
        final result = await repository.updateNote(noteId, 'Note name');
        // Assert
        expect(result, isNotNull);
      });

      test('should throw an exception when the note is not updated', () async {
        // Arrange
        const noteId = 'noteId';

        when(noteService.getNoteById(noteId)).thenAnswer((_) async => null);
        when(noteService.updateNote(noteId, any)).thenAnswer((_) async => null);
        // Act and Assert
        callMethod() async => await repository.updateNote(noteId, 'Note name');
        expect(callMethod, throwsA(isA<Exception>()));
      });
    });

    group('test the deleteNote method', () {
      
      setUp(() {
        noteService = MockLocalNoteService();
        contentServices = [];
        repository = NoteRepository(
          localNoteService: noteService,
          localContentServices: contentServices,
        );
      });

      test('should return true when the note is deleted', () async {
        // Arrange
        const noteId = 'noteId';
        when(noteService.deleteNote(noteId)).thenAnswer((_) async => true);
        // Act
        final result = await repository.deleteNote(noteId);
        // Assert
        expect(result, true);
      });

      test('should return null when the note is not deleted', () async {
        // Arrange
        const noteId = 'noteId';
        when(noteService.deleteNote(noteId)).thenThrow(Exception(''));
        // Act and Assert
        final result = await repository.deleteNote(noteId);
        expect(result, false);
      });
    });

    group('test the getNote method', () {
      
      setUp(() {
        noteService = MockLocalNoteService();
        contentServices = [];
        repository = NoteRepository(
          localNoteService: noteService,
          localContentServices: contentServices,
        );
      });

      test('should return a Note when the note is found', () async {
        // Arrange
        const noteId = 'noteId';
        final noteDto = NoteDto(
          id: noteId,
          name: 'Note name',
          createdAt: DateTime.now(),
          lastEdited: null,
        );
        when(noteService.getNoteById(noteId)).thenAnswer((_) async => noteDto);
        // Act
        final result = await repository.getNote(noteId);
        // Assert
        expect(result, isNotNull);
        expect(result!.id, noteId);
      });

      test('should return null when the note is not found', () async {
        // Arrange
        const noteId = 'noteId';
        when(noteService.getNoteById(noteId)).thenAnswer((_) async => null);
        // Act
        final result = await repository.getNote(noteId);
        // Assert
        expect(result, null);
      });
    });

    group('test the getNotes method', () {
      
      setUp(() {
        noteService = MockLocalNoteService();
        contentServices = [];
        repository = NoteRepository(
          localNoteService: noteService,
          localContentServices: contentServices,
        );
      });

      test('should return a list of Notes when the notes are found', () async {
        // Arrange
        final notes = [
          Note(
            id: 'noteId1',
            name: 'Note name 1',
            createdAt: DateTime.now(),
            lastEdited: null,
            contents: const [],
          ),
          Note(
            id: 'noteId2',
            name: 'Note name 2',
            createdAt: DateTime.now(),
            lastEdited: null,
            contents: const [],
          ),
        ];
        final notesDto = [
          NoteDto(
            id: 'noteId1',
            name: 'Note name 1',
            createdAt: DateTime.now(),
            lastEdited: null,
          ),
          NoteDto(
            id: 'noteId2',
            name: 'Note name 2',
            createdAt: DateTime.now(),
            lastEdited: null,
          ),
        ];
        when(noteService.getNotes()).thenAnswer((_) async => notesDto);
        // Act
        final result = await repository.getNotes();
        // Assert
        expect(result.length, notes.length);
      });

      test('should return an empty list when the notes are not found', () async {
        // Arrange
        when(noteService.getNotes()).thenAnswer((_) async => []);
        // Act
        final result = await repository.getNotes();
        // Assert
        expect(result, []);
      });
    });

  });
}