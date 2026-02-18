import 'package:dio/dio.dart';
import 'picsum_image_model.dart';

class GalleryRepository {
  final Dio _dio;

  GalleryRepository(this._dio);

  Future<List<PicsumImage>> fetchImages({int page = 1, int limit = 30}) async {
    try {
      final response = await _dio.get(
        'https://picsum.photos/v2/list',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => PicsumImage.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      throw Exception('Error fetching images: $e');
    }
  }
}
