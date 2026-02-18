import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picsum_gallery/features/gallery/data/repositories/gallery_repository_impl.dart';
import 'package:picsum_gallery/features/gallery/domain/entities/image_entity.dart';
import 'package:picsum_gallery/features/gallery/domain/repositories/i_gallery_repository.dart';
import 'package:picsum_gallery/core/network/dio_client.dart';

// Provider for Dio instance
final dioProvider = Provider<Dio>((ref) => DioClient.instance);

// Provider for the repository
final galleryRepositoryProvider = Provider<IGalleryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return GalleryRepositoryImpl(dio);
});

// Paginating Image List Provider
final galleryImagesProvider = FutureProvider.family<List<ImageEntity>, int>((ref, page) async {
  final repository = ref.watch(galleryRepositoryProvider);
  return repository.fetchImages(page: page, limit: 30);
});

