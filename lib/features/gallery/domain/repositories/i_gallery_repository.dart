import '../entities/image_entity.dart';

abstract class IGalleryRepository {
  Future<List<ImageEntity>> fetchImages({required int page, required int limit});
}
