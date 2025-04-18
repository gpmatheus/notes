
import 'package:notes/data/repository/implementations/content_repository.dart';
import 'package:notes/data/repository/implementations/image_content_repository.dart';
import 'package:notes/data/repository/implementations/note_repository.dart';
import 'package:notes/data/repository/implementations/text_content_repository.dart';
import 'package:notes/data/repository/implementations/user_repository.dart';
import 'package:notes/data/repository/interfaces/content_repository_interface.dart';
import 'package:notes/data/repository/interfaces/user_repository_interface.dart';
import 'package:notes/data/repository/interfaces/utils/content_type_repository_interface.dart';
import 'package:notes/data/repository/interfaces/note_repository_interface.dart';
import 'package:notes/data/services/file/image_file_service.dart';
import 'package:notes/data/services/interfaces/image_file_service_interface.dart';
import 'package:notes/data/services/interfaces/user_service.dart';
import 'package:notes/data/services/local/config/sqlite_database.dart';
import 'package:notes/data/services/local/local_content_database_sqlite_service.dart';
import 'package:notes/data/services/local/local_imagecontent_database_sqlite_service.dart';
import 'package:notes/data/services/local/local_note_database_sqlite_service.dart';
import 'package:notes/data/services/local/local_textcontent_database_sqlite_service.dart';
import 'package:notes/data/services/interfaces/content_service.dart';
import 'package:notes/data/services/interfaces/content_type_service.dart';
import 'package:notes/data/services/interfaces/note_service.dart';
import 'package:notes/data/services/remote/remote_user_firebase_auth_service.dart';
import 'package:notes/domain/usecases/maintain_notes.dart';
import 'package:notes/domain/usecases/manage_contents.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get _contentsServiceProviders {
  return [
    Provider<LocalTextcontentDatabaseSqliteService>(
      create: (context) => LocalTextcontentDatabaseSqliteService(
        database: context.read<SqliteDatabase>(),
      )
    ),
    Provider<LocalImagecontentDatabaseSqliteService>(
      create: (context) => LocalImagecontentDatabaseSqliteService(
        database: context.read<SqliteDatabase>(),
      )
    ),
    Provider<ImageFileServiceInterface>(
      create: (context) => ImageFileService()
    )
  ];
}

List<SingleChildWidget> get _contentsRepositoriesProviders {
  return [
    Provider<TextContentRepository>(
      create: (context) => TextContentRepository(
        localTextContentService: context.read<LocalTextcontentDatabaseSqliteService>(), 
        localContentService: context.read<ContentService>(),
      )
    ),
    Provider<ImageContentRepository>(
      create: (context) => ImageContentRepository(
        imageContentService: context.read<LocalImagecontentDatabaseSqliteService>(), 
        fileService: context.read<ImageFileServiceInterface>(),
        localContentService: context.read<ContentService>(),
      )
    ),
  ];
}

List<SingleChildWidget> get providers {
  return [
    Provider(
      create: (_) => SqliteDatabase(),
    ),
    Provider<NoteService>(
      create: (context) => LocalNoteDatabaseSqliteService(
        database: context.read<SqliteDatabase>(),
      )
    ),
    Provider<ContentService>(
      create: (context) => LocalContentDatabaseSqliteService(
        database: context.read<SqliteDatabase>(),
      )
    ),
    Provider<UserService>(
      create: (context) => RemoteUserFirebaseAuthService(),
    ),
    ..._contentsServiceProviders,
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
        localNoteService: context.read<NoteService>(),
        localContentServices: context.read<List<ContentTypeService>>(),
      )
    ),
    ..._contentsRepositoriesProviders,
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
    Provider<ContentRepositoryInterface>(
      create: (context) => ContentRepository(
        contentService: context.read<ContentService>(),
      )
    ),
    Provider(
      create: (context) => ManageContents(
        contentRepository: context.read<ContentRepositoryInterface>(), 
        contentTypeRepositories: context.read<List<ContentTypeRepositoryInterface>>(),
      )
    ),
    Provider(
      create: (context) => MaintainNotes(
        noteRepository: context.read<NoteRepositoryInterface>(), 
        manageContents: context.read<ManageContents>(),
      )
    ),
  ];
}