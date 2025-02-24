
import 'package:drift/drift.dart';
import 'package:notes/data/services/local/implementations/model/utils/contents_model.dart';

@DataClassName('TextContentDrift')
class TextContentLocalModel extends ContentsModel {
  TextColumn get textContent => text().named('text')();

  @override
  Set<Column> get primaryKey => {contentId};
}