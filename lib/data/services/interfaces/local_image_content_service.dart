
import 'package:notes/data/services/interfaces/local_content_type_service.dart';
import 'package:notes/data/services/interfaces/model/content/types/image/imagecontent_dto.dart';

abstract class LocalImageContentService extends LocalContentTypeService {

  Future<ImagecontentDto?> createImageContent(ImagecontentDto content);
  Future<ImagecontentDto?> updateImageContent(String contentId, ImagecontentDto content);
}