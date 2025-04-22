
import 'package:notes/data/repository/implementations/content_repository.dart';
import 'package:notes/data/repository/implementations/image_content_repository.dart';
import 'package:notes/data/repository/implementations/note_repository.dart';
import 'package:notes/data/repository/implementations/text_content_repository.dart';
import 'package:notes/data/repository/implementations/user_repository.dart';
import 'package:notes/data/repository/interfaces/user_repository_interface.dart';
import 'package:notes/data/repository/interfaces/utils/content_type_repository_interface.dart';
import 'package:notes/data/repository/interfaces/note_repository_interface.dart';
import 'package:notes/data/services/local/image_file_service.dart';
import 'package:notes/data/services/interfaces/user_service.dart';
import 'package:notes/data/services/local/config/sqlite_database.dart';
import 'package:notes/data/services/local/local_content_database_sqlite_service.dart';
import 'package:notes/data/services/local/local_imagecontent_database_sqlite_service.dart';
import 'package:notes/data/services/local/local_note_database_sqlite_service.dart';
import 'package:notes/data/services/local/local_textcontent_database_sqlite_service.dart';
import 'package:notes/data/services/interfaces/content_type_service.dart';
import 'package:notes/data/services/remote/remote_content_database_firestore_service.dart';
import 'package:notes/data/services/remote/remote_image_file_storage_service.dart';
import 'package:notes/data/services/remote/remote_imagecontent_database_firestore_service.dart';
import 'package:notes/data/services/remote/remote_note_database_firestore_service.dart';
import 'package:notes/data/services/remote/remote_textcontent_database_firestore_service.dart';
import 'package:notes/data/services/remote/remote_user_firebase_auth_service.dart';
import 'package:notes/domain/usecases/maintain_notes.dart';
import 'package:notes/domain/usecases/manage_contents.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';


List<SingleChildWidget> get providers {
  return [
    Provider(
      create: (_) => SqliteDatabase(),
    ),
    Provider<LocalNoteDatabaseSqliteService>(
      create: (context) => LocalNoteDatabaseSqliteService(
        database: context.read<SqliteDatabase>(),
      )
    ),
    Provider<RemoteNoteDatabaseFirestoreService>(
      create: (context) => RemoteNoteDatabaseFirestoreService(),
    ),
    Provider<LocalContentDatabaseSqliteService>(
      create: (context) => LocalContentDatabaseSqliteService(
        database: context.read<SqliteDatabase>(),
      )
    ),
    Provider<UserService>(
      create: (context) => RemoteUserFirebaseAuthService(),
    ),
    Provider<LocalTextcontentDatabaseSqliteService>(
      create: (context) => LocalTextcontentDatabaseSqliteService(
        database: context.read<SqliteDatabase>(),
      )
    ),
    Provider<RemoteTextcontentDatabaseFirestoreService>(
      create: (context) => RemoteTextcontentDatabaseFirestoreService()
    ),
    Provider<LocalImagecontentDatabaseSqliteService>(
      create: (context) => LocalImagecontentDatabaseSqliteService(
        database: context.read<SqliteDatabase>(),
      )
    ),
    Provider<RemoteImagecontentDatabaseFirestoreService>(
      create: (context) => RemoteImagecontentDatabaseFirestoreService(),
    ),
    Provider<ImageFileService>(
      create: (context) => ImageFileService(),
    ),
    Provider<RemoteImageFileStorageService>(
      create: (context) => RemoteImageFileStorageService(),
    ),
    Provider<List<ContentTypeService>>(
      create: (context) {
        ContentTypeService textService = context
          .read<LocalTextcontentDatabaseSqliteService>();
        ContentTypeService imageService = context
          .read<LocalImagecontentDatabaseSqliteService>();
        return [
          textService,
          imageService,
        ];
      }
    ),
    Provider<NoteRepositoryInterface>(
      create: (context) => NoteRepository(
        localNoteService: context.read<LocalNoteDatabaseSqliteService>(),
        localContentServices: context.read<List<ContentTypeService>>(), 
        remoteNoteService: context.read<RemoteNoteDatabaseFirestoreService>(),
      )
    ),
    Provider<RemoteContentDatabaseFirestoreService>(
      create: (context) => RemoteContentDatabaseFirestoreService(),
    ),
    Provider<TextContentRepository>(
      create: (context) => TextContentRepository(
        localTextContentService: context.read<LocalTextcontentDatabaseSqliteService>(), 
        localContentService: context.read<LocalContentDatabaseSqliteService>(), 
        remoteTextContentService: context.read<RemoteTextcontentDatabaseFirestoreService>(), 
        remoteContentService: context.read<RemoteContentDatabaseFirestoreService>(),
      )
    ),
    Provider<ImageContentRepository>(
      create: (context) => ImageContentRepository(
        imageContentService: context.read<LocalImagecontentDatabaseSqliteService>(), 
        fileService: context.read<ImageFileService>(),
        localContentService: context.read<LocalContentDatabaseSqliteService>(), 
        remoteImageContentService: context.read<RemoteImagecontentDatabaseFirestoreService>(), 
        remoteFileService: context.read<RemoteImageFileStorageService>(), 
        remoteContentService: context.read<RemoteContentDatabaseFirestoreService>(),
      )
    ),
    Provider<List<ContentTypeRepositoryInterface>>(
      create: (context) {
        ContentTypeRepositoryInterface textRepository = context.read<TextContentRepository>();
        ContentTypeRepositoryInterface imageRepository = context.read<ImageContentRepository>();
        return [
          textRepository,
          imageRepository,
        ];
      }
    ),
    Provider<UserRepositoryInterface>(
      create: (context) => UserRepository(
        userService: context.read<UserService>(),
      ),
    ),
    Provider<ContentRepository>(
      create: (context) => ContentRepository(
        contentService: context.read<LocalContentDatabaseSqliteService>(), 
        remoteContentService: context.read<RemoteContentDatabaseFirestoreService>(),
      )
    ),
    Provider(
      create: (context) => ManageContents(
        contentRepository: context.read<ContentRepository>(), 
        contentTypeRepositories: context.read<List<ContentTypeRepositoryInterface>>(), 
        userRepository: context.read<UserRepositoryInterface>(),
      )
    ),
    Provider(
      create: (context) => MaintainNotes(
        noteRepository: context.read<NoteRepositoryInterface>(), 
        manageContents: context.read<ManageContents>(),
        userRepository: context.read<UserRepositoryInterface>(),
      )
    ),
  ];
}