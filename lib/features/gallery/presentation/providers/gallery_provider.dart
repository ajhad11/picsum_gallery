import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picsum_gallery/features/gallery/data/repositories/gallery_repository_impl.dart';
import 'package:picsum_gallery/features/gallery/domain/entities/image_entity.dart';
import 'package:picsum_gallery/features/gallery/domain/repositories/i_gallery_repository.dart';
import 'package:picsum_gallery/features/gallery/presentation/providers/favorites_provider.dart';
import 'package:picsum_gallery/core/network/dio_client.dart';
import 'package:picsum_gallery/core/constants/app_constants.dart';

// Provider for Dio instance
final dioProvider = Provider<Dio>((ref) => DioClient.instance);

// Provider for the repository
final galleryRepositoryProvider = Provider<IGalleryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return GalleryRepositoryImpl(dio);
});

// Modern AsyncNotifier for paginated gallery state
class GalleryNotifier extends AsyncNotifier<List<ImageEntity>> {
  int _currentPage = 1;
  List<ImageEntity> _allFetchedImages = [];
  String _searchQuery = '';
  String _sortBy = 'ID'; // 'ID', 'Author'
  String _orientationFilter = 'All'; // 'All', 'Landscape', 'Portrait', 'Square'
  bool _favoritesOnly = false;

  @override
  Future<List<ImageEntity>> build() async {
    // Reactive dependency: Rebuilds filtering when favorites change
    final favorites = ref.watch(favoritesProvider);
    
    // If we have cached images, we just re-apply filters locally
    if (_allFetchedImages.isNotEmpty) {
      return _applyFilters(_allFetchedImages);
    }

    // Initial load
    final images = await _fetchImages(page: 1);
    _allFetchedImages = images;
    return _applyFilters(images);
  }

  Future<List<ImageEntity>> _fetchImages({required int page}) async {
    final repository = ref.read(galleryRepositoryProvider);
    return repository.fetchImages(page: page, limit: AppConstants.defaultLimit);
  }

  List<ImageEntity> _applyFilters(List<ImageEntity> images) {
    var filtered = List<ImageEntity>.from(images);
    
    // Favorites Only filter
    if (_favoritesOnly) {
      final favoriteIds = ref.read(favoritesProvider).value ?? {};
      filtered = filtered.where((img) => favoriteIds.contains(img.id)).toList();
    }
    
    // Search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((img) => 
        img.author.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Orientation filter
    if (_orientationFilter != 'All') {
      filtered = filtered.where((img) {
        if (_orientationFilter == 'Landscape') return img.width > img.height;
        if (_orientationFilter == 'Portrait') return img.height > img.width;
        if (_orientationFilter == 'Square') return img.width == img.height;
        return true;
      }).toList();
    }

    // Sorting
    if (_sortBy == 'Author') {
      filtered.sort((a, b) => a.author.compareTo(b.author));
    } else {
      // Handle non-numeric IDs gracefully if any
      filtered.sort((a, b) {
        final idA = int.tryParse(a.id) ?? 0;
        final idB = int.tryParse(b.id) ?? 0;
        return idA.compareTo(idB);
      });
    }

    return filtered;
  }

  void setQuery(String query) {
    _searchQuery = query;
    state = AsyncValue.data(_applyFilters(_allFetchedImages));
  }

  void setSort(String sortBy) {
    _sortBy = sortBy;
    state = AsyncValue.data(_applyFilters(_allFetchedImages));
  }

  void setOrientation(String orientation) {
    _orientationFilter = orientation;
    state = AsyncValue.data(_applyFilters(_allFetchedImages));
  }

  void toggleFavoritesOnly() {
    _favoritesOnly = !_favoritesOnly;
    state = AsyncValue.data(_applyFilters(_allFetchedImages));
  }

  String get currentOrientation => _orientationFilter;
  bool get favoritesOnly => _favoritesOnly;

  Future<void> fetchNextPage() async {
    if (state.isLoading) return;

    _currentPage++;
    // ignore: invalid_use_of_internal_member
    state = const AsyncLoading<List<ImageEntity>>().copyWithPrevious(state);

    final result = await AsyncValue.guard(() async {
      final newImages = await _fetchImages(page: _currentPage);
      _allFetchedImages.addAll(newImages);
      return _applyFilters(_allFetchedImages);
    });
    
    state = result;
  }

  Future<void> refresh() async {
    _currentPage = 1;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final images = await _fetchImages(page: 1);
      _allFetchedImages = images;
      return _applyFilters(images);
    });
  }
}


final galleryImagesProvider = AsyncNotifierProvider<GalleryNotifier, List<ImageEntity>>(() {
  return GalleryNotifier();
});



