import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class SearchState {
  const SearchState();
}

final class SearchInitial extends SearchState {
  const SearchInitial();
}

final class SearchLoading extends SearchState {
  const SearchLoading();
}

final class SearchSuccess extends SearchState {
  const SearchSuccess({
    required this.categories,
    required this.foods,
    required this.query,
    required this.selectedCategoryId,
    required this.recentSearches,
  });

  final List<CategoryModel> categories;
  final List<FoodModel> foods;
  final String query;
  final String? selectedCategoryId;
  final List<String> recentSearches;

  List<FoodModel> get filteredFoods {
    final normalizedQuery = query.trim().toLowerCase();
    return foods.where((food) {
      final matchesCategory =
          selectedCategoryId == null ||
          food.categoryId == selectedCategoryId;
      final matchesQuery =
          normalizedQuery.isEmpty ||
          food.name.toLowerCase().contains(normalizedQuery) ||
          food.description.toLowerCase().contains(normalizedQuery);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  SearchSuccess copyWith({
    List<CategoryModel>? categories,
    List<FoodModel>? foods,
    String? query,
    String? Function()? selectedCategoryId,
    List<String>? recentSearches,
  }) {
    return SearchSuccess(
      categories: categories ?? this.categories,
      foods: foods ?? this.foods,
      query: query ?? this.query,
      selectedCategoryId: selectedCategoryId != null
          ? selectedCategoryId()
          : this.selectedCategoryId,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}

final class SearchFailure extends SearchState {
  const SearchFailure(this.failure);

  final Failure failure;
}