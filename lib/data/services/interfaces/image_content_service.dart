
import 'package:notes/data/services/interfaces/content_type_service.dart';
import 'package:notes/data/services/interfaces/model/content/types/image/imagecontent_dto.dart';

abstract class ImageContentService extends ContentTypeService {

  Future<ImagecontentDto?> createImageContent(ImagecontentDto content);
  Future<ImagecontentDto?> updateImageContent(String contentId, ImagecontentDto content);
}