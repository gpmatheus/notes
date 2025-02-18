
import 'package:notes/data/services/local/interfaces/local_content_type_service.dart';
import 'package:notes/data/services/local/interfaces/model/content/types/text/textcontent_dto.dart';

abstract class LocalTextContentService extends LocalContentTypeService {

  Future<TextcontentDto?> createTextContent(TextcontentDto content);
  Future<TextcontentDto?> updateTextContent(String contentId, TextcontentDto content);
}