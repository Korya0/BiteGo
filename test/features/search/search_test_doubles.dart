import 'dart:async';

import 'package:bite_go/core/services/local_storage.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/home/data/models/banner_model.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:bite_go/features/home/data/repositories/home_repository.dart';

class FakeHomeRepository implements HomeRepository {
  FakeHomeRepository({
    required this.foodsResult,
    required this.categoriesResult,
  });

  Result<List<FoodModel>> foodsResult;
  Result<List<CategoryModel>> categoriesResult;

  @override
  Future<Result<List<BannerModel>>> getBanners() async => const Success([]);

  @override
  Future<Result<List<CategoryModel>>> getCategories() async => categoriesResult;

  @override
  Future<Result<List<FoodModel>>> getFoods() async => foodsResult;
}

class HangingHomeRepository implements HomeRepository {
  @override
  Future<Result<List<BannerModel>>> getBanners() =>
      Completer<Result<List<BannerModel>>>().future;

  @override
  Future<Result<List<CategoryModel>>> getCategories() =>
      Completer<Result<List<CategoryModel>>>().future;

  @override
  Future<Result<List<FoodModel>>> getFoods() =>
      Completer<Result<List<FoodModel>>>().future;
}

class FakeLocalStorage implements LocalStorage {
  final Map<String, dynamic> store = {};

  @override
  Future<void> write<T>(String key, T value) async {
    store[key] = value;
  }

  @override
  T? read<T>(String key) => store[key] as T?;

  @override
  Future<void> delete(String key) async {
    store.remove(key);
  }

  @override
  Future<void> clear() async {
    store.clear();
  }

  @override
  bool contains(String key) => store.containsKey(key);
}

final List<FoodModel> testFoods = [
  FoodModel(
    id: 'f1',
    name: 'Margherita Pizza',
    description: 'Cheesy classic with basil',
    imageUrl: '',
    price: 10000,
    rating: 4.6,
    categoryId: 'pizza',
    isAvailable: true,
    sortOrder: 1,
  ),
  FoodModel(
    id: 'f2',
    name: 'Ordinary Burgers',
    description: 'Juicy beef burger',
    imageUrl: '',
    price: 12000,
    rating: 4.9,
    categoryId: 'burger',
    isAvailable: true,
    sortOrder: 2,
  ),
];

final List<CategoryModel> testCategories = [
  CategoryModel(id: 'pizza', name: 'Pizza', sortOrder: 1),
  CategoryModel(id: 'burger', name: 'Burger', sortOrder: 2),
];