abstract class IFavoritesRepository {
  Future<List<String>> getFavorites();
  Future<void> addFavorite(String id);
  Future<void> removeFavorite(String id);
  Future<bool> isFavorite(String id);
}
