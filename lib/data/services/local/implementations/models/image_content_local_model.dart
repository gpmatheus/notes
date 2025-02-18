
import 'package:drift/drift.dart';
import 'package:notes/data/services/local/implementations/models/utils/contents_model.dart';

@DataClassName('ImageContentDrift')
class ImageContentLocalModel extends ContentsModel {
  TextColumn get imageFileName => text().unique().named('image_file_name')();

  @override
  Set<Column> get primaryKey => {contentId};
}