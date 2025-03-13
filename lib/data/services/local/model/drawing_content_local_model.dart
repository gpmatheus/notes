
import 'package:drift/drift.dart';
import 'package:notes/data/services/local/model/utils/contents_model.dart';

@DataClassName('DrawingContentDrift')
class DrawingContentLocalModel extends ContentsModel {
  TextColumn get drawingJsonContent => text().named('drawing')();

  @override
  Set<Column> get primaryKey => {contentId};
}