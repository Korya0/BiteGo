import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/home/data/models/banner_model.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:bite_go/features/home/data/repositories/home_repository.dart';
import 'package:bite_go/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required HomeRepository homeRepository})
      : _homeRepository = homeRepository,
        super(const HomeInitial());

  final HomeRepository _homeRepository;

  Future<void> loadHomeData() async {
    if (state is HomeLoading) {
      return;
    }
    emit(const HomeLoading());

    final results = await Future.wait([
      _homeRepository.getBanners(),
      _homeRepository.getCategories(),
      _homeRepository.getFoods(),
    ]);

    if (isClosed) {
      return;
    }

    final bannersResult = results[0] as Result<List<BannerModel>>;
    final categoriesResult = results[1] as Result<List<CategoryModel>>;
    final foodsResult = results[2] as Result<List<FoodModel>>;

    if (bannersResult is Error<List<BannerModel>>) {
      emit(HomeFailure(bannersResult.failure));
      return;
    }
    if (categoriesResult is Error<List<CategoryModel>>) {
      emit(HomeFailure(categoriesResult.failure));
      return;
    }
    if (foodsResult is Error<List<FoodModel>>) {
      emit(HomeFailure(foodsResult.failure));
      return;
    }

    emit(
      HomeSuccess(
        banners: (bannersResult as Success<List<BannerModel>>).data,
        categories: (categoriesResult as Success<List<CategoryModel>>).data,
        foods: (foodsResult as Success<List<FoodModel>>).data,
        selectedCategoryId: null,
      ),
    );
  }

  void selectCategory(String? categoryId) {
    final current = state;
    if (current is! HomeSuccess) {
      return;
    }
    emit(current.copyWith(selectedCategoryId: () => categoryId));
  }
}
