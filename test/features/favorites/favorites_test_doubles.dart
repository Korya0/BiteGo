import 'dart:async';

import 'package:bite_go/core/logging/error_reporter.dart';
import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/data/repositories/auth_repository.dart';
import 'package:bite_go/features/favorites/data/models/favorite_model.dart';
import 'package:bite_go/features/favorites/data/repositories/favorites_repository.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';

class FakeAuthRepository implements AuthRepository {
  final StreamController<Result<UserModel?>> controller =
      StreamController<Result<UserModel?>>.broadcast();

  @override
  Stream<Result<UserModel?>> get authStateChanges => controller.stream;

  @override
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Result<UserModel>> signUp({
    required String email,
    required String password,
    required String username,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Result<UserModel>> signInWithGoogle() {
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> sendPasswordResetEmail({required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> logout() async => const Success(null);

  Future<void> close() => controller.close();
}

class FakeErrorReporter implements ErrorReporter {
  @override
  Future<void> report(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, Object>? metadata,
    bool fatal = false,
  }) async {}

  @override
  void setUserIdentifier(String? identifier) {}
}

class FakeFavoritesRepository implements FavoritesRepository {
  final StreamController<Result<List<FavoriteModel>>> _controller =
      StreamController<Result<List<FavoriteModel>>>.broadcast();

  final List<FavoriteModel> favorites = [];
  final List<String> addedIds = [];
  final List<String> removedIds = [];
  final List<List<String>> removedBatches = [];

  @override
  Stream<Result<List<FavoriteModel>>> watchFavorites(String uid) {
    return _controller.stream;
  }

  @override
  Future<Result<void>> addFavorite(String uid, FavoriteModel favorite) async {
    addedIds.add(favorite.id);
    favorites.removeWhere((item) => item.id == favorite.id);
    favorites.insert(0, favorite);
    _emitCurrent();
    return const Success(null);
  }

  @override
  Future<Result<void>> removeFavorite(String uid, String foodId) async {
    removedIds.add(foodId);
    favorites.removeWhere((favorite) => favorite.id == foodId);
    _emitCurrent();
    return const Success(null);
  }

  @override
  Future<Result<void>> removeFavorites(String uid, List<String> foodIds) async {
    removedBatches.add(List.of(foodIds));
    favorites.removeWhere((favorite) => foodIds.contains(favorite.id));
    _emitCurrent();
    return const Success(null);
  }

  void emit(List<FavoriteModel> list) {
    favorites
      ..clear()
      ..addAll(list);
    _controller.add(Success(List.of(favorites)));
  }

  void emitError(Failure failure) {
    _controller.add(Error<List<FavoriteModel>>(failure));
  }

  void _emitCurrent() {
    _controller.add(Success(List.of(favorites)));
  }

  Future<void> close() => _controller.close();
}

final UserModel testUser = UserModel(
  uid: 'uid-1',
  email: 'test@bitego.com',
  username: 'Bite',
  createdAt: DateTime(2026, 1, 1),
);

FoodModel testFood({
  String id = 'f1',
  String name = 'Margherita Pizza',
  String categoryId = 'pizza',
}) {
  return FoodModel(
    id: id,
    name: name,
    description: 'Cheesy classic with basil',
    imageUrl: '',
    price: 10000,
    rating: 4.6,
    categoryId: categoryId,
    isAvailable: true,
    sortOrder: 1,
  );
}

FavoriteModel testFavorite({
  String id = 'f1',
  String name = 'Margherita Pizza',
  String categoryId = 'pizza',
}) {
  return FavoriteModel(
    food: testFood(id: id, name: name, categoryId: categoryId),
    addedAt: DateTime(2026, 1, 1),
  );
}