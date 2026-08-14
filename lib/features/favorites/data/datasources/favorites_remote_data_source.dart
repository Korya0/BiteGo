import 'package:bite_go/features/favorites/data/models/favorite_model.dart';

abstract interface class FavoritesRemoteDataSource {
  Stream<List<FavoriteModel>> watchFavorites(String uid);
  Future<void> addFavorite(String uid, FavoriteModel favorite);
  Future<void> removeFavorite(String uid, String foodId);
  Future<void> removeFavorites(String uid, List<String> foodIds);
}