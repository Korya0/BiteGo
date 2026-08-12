import 'package:bite_go/core/logging/app_logger.dart';
import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/home/data/datasources/home_remote_data_source.dart';
import 'package:bite_go/features/home/data/models/banner_model.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:bite_go/features/home/data/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    required HomeRemoteDataSource homeRemoteDataSource,
    required AppLogger appLogger,
  })  : _homeRemoteDataSource = homeRemoteDataSource,
        _appLogger = appLogger;

  final HomeRemoteDataSource _homeRemoteDataSource;
  final AppLogger _appLogger;

  @override
  Future<Result<List<BannerModel>>> getBanners() {
    return _guard(() => _homeRemoteDataSource.getBanners());
  }

  @override
  Future<Result<List<CategoryModel>>> getCategories() {
    return _guard(() => _homeRemoteDataSource.getCategories());
  }

  @override
  Future<Result<List<FoodModel>>> getFoods() {
    return _guard(() => _homeRemoteDataSource.getFoods());
  }

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on Exception catch (error, stackTrace) {
      _appLogger.error(
        'HomeRepository: unexpected failure',
        error: error,
        stackTrace: stackTrace,
        report: true,
      );
      return const Error(UnknownFailure());
    }
  }
}
