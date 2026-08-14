import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/features/favorites/data/models/favorite_model.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class FavoritesState {
  const FavoritesState();
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

final class FavoritesSuccess extends FavoritesState {
  const FavoritesSuccess({
    required this.favorites,
    this.selectedIds = const {},
    this.isSelectionMode = false,
  });

  final List<FavoriteModel> favorites;
  final Set<String> selectedIds;
  final bool isSelectionMode;

  bool isFavorite(String foodId) {
    return favorites.any((favorite) => favorite.id == foodId);
  }

  FavoritesSuccess copyWith({
    List<FavoriteModel>? favorites,
    Set<String>? selectedIds,
    bool? isSelectionMode,
  }) {
    return FavoritesSuccess(
      favorites: favorites ?? this.favorites,
      selectedIds: selectedIds ?? this.selectedIds,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
    );
  }
}

final class FavoritesFailure extends FavoritesState {
  const FavoritesFailure(this.failure);

  final Failure failure;
}