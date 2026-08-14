import 'package:bite_go/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:bite_go/features/favorites/data/models/favorite_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  FavoritesRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Stream<List<FavoriteModel>> watchFavorites(String uid) {
    return _favoritesCollection(uid)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => FavoriteModel.fromFirestore(
                  doc.data(),
                  documentId: doc.id,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<void> addFavorite(String uid, FavoriteModel favorite) {
    return _favoritesCollection(uid)
        .doc(favorite.id)
        .set(favorite.toFirestoreMap());
  }

  @override
  Future<void> removeFavorite(String uid, String foodId) {
    return _favoritesCollection(uid).doc(foodId).delete();
  }

  @override
  Future<void> removeFavorites(String uid, List<String> foodIds) {
    if (foodIds.isEmpty) {
      return Future.value();
    }
    final batch = _firestore.batch();
    for (final foodId in foodIds) {
      batch.delete(_favoritesCollection(uid).doc(foodId));
    }
    return batch.commit();
  }

  CollectionReference<Map<String, dynamic>> _favoritesCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('favorites');
  }
}