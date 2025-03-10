
import 'package:notes/data/repository/implementations/content_repository.dart';
import 'package:notes/data/repository/implementations/image_content_repository.dart';
import 'package:notes/data/repository/implementations/note_repository.dart';
import 'package:notes/data/repository/implementations/text_content_repository.dart';
import 'package:notes/data/repository/interfaces/content_repository_interface.dart';
import 'package:notes/data/repository/interfaces/utils/content_type_repository_interface.dart';
import 'package:notes/data/repository/interfaces/note_repository_interface.dart';
import 'package:notes/data/services/file/implementations/image_file_service.dart';
import 'package:notes/data/services/file/interfaces/image_file_service_interface.dart';
import 'package:notes/data/services/local/implementations/config/sqlite_database.dart';
import 'package:notes/data/services/local/implementations/local_content_database_sqlite_service.dart';
import 'package:notes/data/services/local/implementations/local_imagecontent_database_sqlite_service.dart';
import 'package:notes/data/services/local/implementations/local_note_database_sqlite_service.dart';
import 'package:notes/data/services/local/implementations/local_textcontent_database_sqlite_service.dart';
import 'package:notes/data/services/local/interfaces/local_content_service.dart';
import 'package:notes/data/services/local/interfaces/local_content_type_service.dart';
import 'package:notes/data/services/local/interfaces/local_note_service.dart';
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
        localContentService: context.read<LocalContentService>(),
      )
    ),
    Provider<ImageContentRepository>(
      create: (context) => ImageContentRepository(
        imageContentService: context.read<LocalImagecontentDatabaseSqliteService>(), 
        fileService: context.read<ImageFileServiceInterface>(),
        localContentService: context.read<LocalContentService>(),
      )
    ),
  ];
}

List<SingleChildWidget> get providers {
  return [
    Provider(
      create: (_) => SqliteDatabase(),
    ),
    Provider<LocalNoteService>(
      create: (context) => LocalNoteDatabaseSqliteService(
        database: context.read<SqliteDatabase>(),
      )
    ),
    Provider<LocalContentService>(
      create: (context) => LocalContentDatabaseSqliteService(
        database: context.read<SqliteDatabase>(),
      )
    ),
    ..._contentsServiceProviders,
    Provider<List<LocalContentTypeService>>(
      create: (context) {
        LocalContentTypeService textService = context
          .read<LocalTextcontentDatabaseSqliteService>();
        LocalContentTypeService imageService = context
          .read<LocalImagecontentDatabaseSqliteService>();
        return [
          textService,
          imageService,
        ];
      }
    ),
    Provider<NoteRepositoryInterface>(
      create: (context) => NoteRepository(
        localNoteService: context.read<LocalNoteService>(),
        localContentServices: context.read<List<LocalContentTypeService>>(),
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
    Provider<ContentRepositoryInterface>(
      create: (context) => ContentRepository(
        contentService: context.read<LocalContentService>(),
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