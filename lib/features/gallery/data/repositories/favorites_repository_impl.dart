import 'package:shared_preferences/shared_preferences.dart';
import 'package:picsum_gallery/features/gallery/domain/repositories/i_favorites_repository.dart';

class FavoritesRepositoryImpl implements IFavoritesRepository {
  static const String _key = 'favorite_image_ids';

  @override
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  @override
  Future<void> addFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];
    if (!favorites.contains(id)) {
      favorites.add(id);
      await prefs.setStringList(_key, favorites);
    }
  }

  @override
  Future<void> removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];
    if (favorites.contains(id)) {
      favorites.remove(id);
      await prefs.setStringList(_key, favorites);
    }
  }

  @override
  Future<bool> isFavorite(String id) async {
    final favorites = await getFavorites();
    return favorites.contains(id);
  }
}
