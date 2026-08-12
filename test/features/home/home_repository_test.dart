import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeHomeRemoteDataSource dataSource;
  late FakeAppLogger logger;
  late HomeRepositoryImpl repository;

  setUp(() {
    dataSource = FakeHomeRemoteDataSource();
    logger = FakeAppLogger();
    repository = HomeRepositoryImpl(
      homeRemoteDataSource: dataSource,
      appLogger: logger,
    );
  });

  group('HomeRepositoryImpl', () {
    test('returns banners on success', () async {
      final result = await repository.getBanners();

      expect(result, isA<Success<List<Object?>>>());
      expect((result as Success).data, [tBanner]);
    });

    test('returns categories on success', () async {
      final result = await repository.getCategories();

      expect(result, isA<Success<List<Object?>>>());
      expect((result as Success).data, [tCategory]);
    });

    test('returns foods on success', () async {
      final result = await repository.getFoods();

      expect(result, isA<Success<List<Object?>>>());
      expect((result as Success).data, [tFood]);
    });

    test('maps banners failure to UnknownFailure and logs it', () async {
      dataSource.bannersError = Exception('boom');

      final result = await repository.getBanners();

      expect(result, isA<Error<List<Object?>>>());
      expect((result as Error).failure, isA<UnknownFailure>());
      expect(logger.errors, isNotEmpty);
    });

    test('maps categories failure to UnknownFailure', () async {
      dataSource.categoriesError = Exception('boom');

      final result = await repository.getCategories();

      expect(result, isA<Error<List<Object?>>>());
      expect((result as Error).failure, isA<UnknownFailure>());
    });

    test('maps foods failure to UnknownFailure', () async {
      dataSource.foodsError = Exception('boom');

      final result = await repository.getFoods();

      expect(result, isA<Error<List<Object?>>>());
      expect((result as Error).failure, isA<UnknownFailure>());
    });
  });
}
