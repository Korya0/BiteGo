import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/features/home/data/models/banner_model.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeSuccess extends HomeState {
  const HomeSuccess({
    required this.banners,
    required this.categories,
    required this.foods,
    required this.selectedCategoryId,
  });

  final List<BannerModel> banners;
  final List<CategoryModel> categories;
  final List<FoodModel> foods;
  final String? selectedCategoryId;

  List<FoodModel> get filteredFoods {
    if (selectedCategoryId == null) {
      return foods;
    }
    return foods
        .where((food) => food.categoryId == selectedCategoryId)
        .toList();
  }

  HomeSuccess copyWith({
    List<BannerModel>? banners,
    List<CategoryModel>? categories,
    List<FoodModel>? foods,
    String? Function()? selectedCategoryId,
  }) {
    return HomeSuccess(
      banners: banners ?? this.banners,
      categories: categories ?? this.categories,
      foods: foods ?? this.foods,
      selectedCategoryId: selectedCategoryId != null
          ? selectedCategoryId()
          : this.selectedCategoryId,
    );
  }
}

final class HomeFailure extends HomeState {
  const HomeFailure(this.failure);

  final Failure failure;
}
