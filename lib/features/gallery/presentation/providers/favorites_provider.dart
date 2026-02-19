import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picsum_gallery/features/gallery/data/repositories/favorites_repository_impl.dart';
import 'package:picsum_gallery/features/gallery/domain/repositories/i_favorites_repository.dart';

final favoritesRepositoryProvider = Provider<IFavoritesRepository>((ref) {
  return FavoritesRepositoryImpl();
});

class FavoritesNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    final repository = ref.watch(favoritesRepositoryProvider);
    final list = await repository.getFavorites();
    return list.toSet();
  }

  Future<void> toggleFavorite(String id) async {
    final repository = ref.read(favoritesRepositoryProvider);
    final current = state.value ?? {};
    
    if (current.contains(id)) {
      await repository.removeFavorite(id);
      state = AsyncValue.data(current.where((item) => item != id).toSet());
    } else {
      await repository.addFavorite(id);
      state = AsyncValue.data({...current, id});
    }
  }

  bool isFavorite(String id) {
    return state.value?.contains(id) ?? false;
  }
}

final favoritesProvider = AsyncNotifierProvider<FavoritesNotifier, Set<String>>(() {
  return FavoritesNotifier();
});
