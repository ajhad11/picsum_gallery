import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/gallery_repository.dart';
import '../../data/picsum_image_model.dart';

// Provider for Dio instance
final dioProvider = Provider<Dio>((ref) => Dio());

// Provider for the repository
final galleryRepositoryProvider = Provider<GalleryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return GalleryRepository(dio);
});

// FutureProvider to fetch the list of images
final galleryImagesProvider = FutureProvider.autoDispose<List<PicsumImage>>((ref) async {
  final repository = ref.watch(galleryRepositoryProvider);
  return repository.fetchImages();
});
