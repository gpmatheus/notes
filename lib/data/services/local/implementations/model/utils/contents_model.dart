
import 'package:drift/drift.dart';
import 'package:notes/data/services/local/implementations/model/content_local_model.dart';

abstract class ContentsModel extends Table {
  TextColumn get contentId => text().references(ContentLocalModel, #id, onDelete: KeyAction.cascade)();
}