
import 'package:notes/data/services/interfaces/content_type_service.dart';
import 'package:notes/data/services/interfaces/model/content/types/text/textcontent_dto.dart';

abstract class TextContentService extends ContentTypeService {

  Future<TextcontentDto?> createTextContent(TextcontentDto content);
  Future<TextcontentDto?> updateTextContent(String contentId, TextcontentDto content);
}