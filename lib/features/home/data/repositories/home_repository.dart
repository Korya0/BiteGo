import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/home/data/models/banner_model.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';

abstract interface class HomeRepository {
  Future<Result<List<BannerModel>>> getBanners();
  Future<Result<List<CategoryModel>>> getCategories();
  Future<Result<List<FoodModel>>> getFoods();
}
