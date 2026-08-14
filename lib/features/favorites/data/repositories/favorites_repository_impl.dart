import 'dart:async';

import 'package:bite_go/core/logging/app_logger.dart';
import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:bite_go/features/favorites/data/models/favorite_model.dart';
import 'package:bite_go/features/favorites/data/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({
    required FavoritesRemoteDataSource favoritesRemoteDataSource,
    required AppLogger appLogger,
  })  : _favoritesRemoteDataSource = favoritesRemoteDataSource,
        _appLogger = appLogger;

  final FavoritesRemoteDataSource _favoritesRemoteDataSource;
  final AppLogger _appLogger;

  @override
  Stream<Result<List<FavoriteModel>>> watchFavorites(String uid) {
    return _favoritesRemoteDataSource
        .watchFavorites(uid)
        .map((favorites) => Success<List<FavoriteModel>>(favorites))
        .handleError(
          (Object error, StackTrace stackTrace) =>
              Error<List<FavoriteModel>>(_handleFailure(error, stackTrace)),
        );
  }

  @override
  Future<Result<void>> addFavorite(String uid, FavoriteModel favorite) {
    return _guard(() => _favoritesRemoteDataSource.addFavorite(uid, favorite));
  }

  @override
  Future<Result<void>> removeFavorite(String uid, String foodId) {
    return _guard(() => _favoritesRemoteDataSource.removeFavorite(uid, foodId));
  }

  @override
  Future<Result<void>> removeFavorites(String uid, List<String> foodIds) {
    return _guard(
      () => _favoritesRemoteDataSource.removeFavorites(uid, foodIds),
    );
  }

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on Exception catch (error, stackTrace) {
      return Error(_handleFailure(error, stackTrace));
    }
  }

  Failure _handleFailure(Object error, StackTrace stackTrace) {
    _appLogger.error(
      'FavoritesRepository: unexpected failure',
      error: error,
      stackTrace: stackTrace,
      report: true,
    );
    return const UnknownFailure();
  }
}