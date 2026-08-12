import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/home/data/models/banner_model.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:bite_go/features/home/presentation/cubit/home_cubit.dart';
import 'package:bite_go/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeHomeRepository repository;
  late HomeCubit cubit;

  setUp(() {
    repository = FakeHomeRepository();
    cubit = HomeCubit(homeRepository: repository);
  });

  tearDown(() async {
    if (!cubit.isClosed) {
      await cubit.close();
    }
  });

  group('HomeCubit', () {
    test('initial state is HomeInitial', () {
      expect(cubit.state, isA<HomeInitial>());
    });

    test('loadHomeData fetches banners, categories and foods', () async {
      repository.bannersResult = Success([tBanner]);
      repository.categoriesResult = Success([tCategory]);
      repository.foodsResult = Success([tFood]);

      await cubit.loadHomeData();

      expect(repository.getBannersCalls, 1);
      expect(repository.getCategoriesCalls, 1);
      expect(repository.getFoodsCalls, 1);
      final state = cubit.state;
      expect(state, isA<HomeSuccess>());
      expect((state as HomeSuccess).banners, [tBanner]);
      expect(state.categories, [tCategory]);
      expect(state.foods, [tFood]);
      expect(state.selectedCategoryId, isNull);
    });

    test('loadHomeData emits HomeFailure when banners fail', () async {
      repository.bannersResult = const Error(UnknownFailure());

      await cubit.loadHomeData();

      expect(cubit.state, isA<HomeFailure>());
    });

    test('loadHomeData emits HomeFailure when categories fail', () async {
      repository.categoriesResult = const Error(UnknownFailure());

      await cubit.loadHomeData();

      expect(cubit.state, isA<HomeFailure>());
    });

    test('loadHomeData emits HomeFailure when foods fail', () async {
      repository.foodsResult = const Error(UnknownFailure());

      await cubit.loadHomeData();

      expect(cubit.state, isA<HomeFailure>());
    });

    test('selectCategory updates the selected category on success', () async {
      repository.bannersResult = const Success(<BannerModel>[]);
      repository.categoriesResult = const Success(<CategoryModel>[]);
      repository.foodsResult = const Success(<FoodModel>[]);
      await cubit.loadHomeData();

      cubit.selectCategory('pizza');

      expect(
        (cubit.state as HomeSuccess).selectedCategoryId,
        'pizza',
      );
    });

    test('selectCategory is ignored when not in success state', () async {
      cubit.selectCategory('pizza');

      expect(cubit.state, isA<HomeInitial>());
    });
  });
}
