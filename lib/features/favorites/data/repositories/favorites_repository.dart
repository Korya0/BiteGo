import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/favorites/data/models/favorite_model.dart';

abstract interface class FavoritesRepository {
  Stream<Result<List<FavoriteModel>>> watchFavorites(String uid);
  Future<Result<void>> addFavorite(String uid, FavoriteModel favorite);
  Future<Result<void>> removeFavorite(String uid, String foodId);
  Future<Result<void>> removeFavorites(String uid, List<String> foodIds);
}