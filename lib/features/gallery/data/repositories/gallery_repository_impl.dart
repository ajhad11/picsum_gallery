import 'package:dio/dio.dart';
import 'package:picsum_gallery/features/gallery/domain/entities/image_entity.dart';
import 'package:picsum_gallery/features/gallery/domain/repositories/i_gallery_repository.dart';
import 'package:picsum_gallery/features/gallery/data/models/image_model.dart';
import 'package:picsum_gallery/core/constants/app_constants.dart';

class GalleryRepositoryImpl implements IGalleryRepository {
  final Dio _dio;

  GalleryRepositoryImpl(this._dio);

  @override
  Future<List<ImageEntity>> fetchImages({required int page, required int limit}) async {
    try {
      final response = await _dio.get(
        AppConstants.baseUrl,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ImageModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
