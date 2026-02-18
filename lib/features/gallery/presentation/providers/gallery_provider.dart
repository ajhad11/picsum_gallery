import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/gallery_repository_impl.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/repositories/i_gallery_repository.dart';

import '../../../core/network/dio_client.dart';

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

// Current Page Provider
final currentPageProvider = StateProvider<int>((ref) => 1);
