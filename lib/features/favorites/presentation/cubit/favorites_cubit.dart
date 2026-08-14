import 'dart:async';

import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_state.dart';
import 'package:bite_go/features/favorites/data/models/favorite_model.dart';
import 'package:bite_go/features/favorites/data/repositories/favorites_repository.dart';
import 'package:bite_go/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({
    required AuthSessionCubit authSessionCubit,
    required FavoritesRepository favoritesRepository,
  })  : _authSessionCubit = authSessionCubit,
        _favoritesRepository = favoritesRepository,
        super(const FavoritesInitial()) {
    _authSubscription = _authSessionCubit.stream.listen(_onAuthStateChanged);
    _onAuthStateChanged(_authSessionCubit.state);
  }

  final AuthSessionCubit _authSessionCubit;
  final FavoritesRepository _favoritesRepository;

  StreamSubscription<AuthSessionState>? _authSubscription;
  StreamSubscription<Result<List<FavoriteModel>>>? _favoritesSubscription;
  String? _uid;

  void _onAuthStateChanged(AuthSessionState state) {
    switch (state) {
      case Authenticated(:final user):
        _subscribe(user.uid);
      case AuthSessionUnknown() || Unauthenticated():
        _uid = null;
        _favoritesSubscription?.cancel();
        _favoritesSubscription = null;
        emit(const FavoritesSuccess(favorites: []));
    }
  }

  void _subscribe(String uid) {
    _uid = uid;
    _favoritesSubscription?.cancel();
    emit(const FavoritesInitial());
    _favoritesSubscription = _favoritesRepository.watchFavorites(uid).listen(
      (result) {
        if (isClosed) {
          return;
        }
        switch (result) {
          case Success<List<FavoriteModel>>(data: final favorites):
            emit(_toSuccess(favorites));
          case Error<List<FavoriteModel>>():
            emit(FavoritesFailure(result.failure));
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        if (isClosed) {
          return;
        }
        emit(const FavoritesFailure(UnknownFailure()));
      },
    );
  }

  FavoritesSuccess _toSuccess(List<FavoriteModel> favorites) {
    final current = state;
    if (current is! FavoritesSuccess) {
      return FavoritesSuccess(favorites: favorites);
    }
    final selectedIds = current.selectedIds
        .where((id) => favorites.any((favorite) => favorite.id == id))
        .toSet();
    return FavoritesSuccess(
      favorites: favorites,
      selectedIds: selectedIds,
      isSelectionMode: current.isSelectionMode && selectedIds.isNotEmpty,
    );
  }

  bool isFavorite(String foodId) {
    final current = state;
    return current is FavoritesSuccess && current.isFavorite(foodId);
  }

  Future<void> toggleFavorite(FoodModel food) async {
    final uid = _uid;
    if (uid == null) {
      return;
    }
    if (isFavorite(food.id)) {
      await _favoritesRepository.removeFavorite(uid, food.id);
    } else {
      await _favoritesRepository.addFavorite(uid, FavoriteModel.fromFood(food));
    }
  }

  Future<void> removeFavorite(String foodId) async {
    final uid = _uid;
    if (uid == null) {
      return;
    }
    await _favoritesRepository.removeFavorite(uid, foodId);
  }

  void enterSelectionMode() {
    final current = state;
    if (current is! FavoritesSuccess || current.favorites.isEmpty) {
      return;
    }
    emit(
      current.copyWith(isSelectionMode: true, selectedIds: const {}),
    );
  }

  void exitSelectionMode() {
    final current = state;
    if (current is! FavoritesSuccess) {
      return;
    }
    emit(
      current.copyWith(isSelectionMode: false, selectedIds: const {}),
    );
  }

  void toggleSelection(String foodId) {
    final current = state;
    if (current is! FavoritesSuccess || !current.isSelectionMode) {
      return;
    }
    final selectedIds = Set<String>.of(current.selectedIds);
    if (!selectedIds.add(foodId)) {
      selectedIds.remove(foodId);
    }
    emit(current.copyWith(selectedIds: selectedIds));
  }

  Future<void> deleteSelected() async {
    final current = state;
    if (current is! FavoritesSuccess || current.selectedIds.isEmpty) {
      return;
    }
    final uid = _uid;
    if (uid == null) {
      return;
    }
    await _favoritesRepository.removeFavorites(uid, current.selectedIds.toList());
  }

  void retry() {
    final uid = _uid;
    if (uid == null) {
      return;
    }
    _subscribe(uid);
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    await _favoritesSubscription?.cancel();
    await super.close();
  }
}