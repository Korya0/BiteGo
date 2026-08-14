import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_cubit.dart';
import 'package:bite_go/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:bite_go/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'favorites_test_doubles.dart';

FavoritesSuccess successOf(FavoritesCubit cubit) =>
    cubit.state as FavoritesSuccess;

void main() {
  late FakeAuthRepository authRepository;
  late AuthSessionCubit authSessionCubit;
  late FakeFavoritesRepository favoritesRepository;
  late FavoritesCubit cubit;

  setUp(() {
    authRepository = FakeAuthRepository();
    authSessionCubit = AuthSessionCubit(
      authRepository: authRepository,
      errorReporter: FakeErrorReporter(),
    );
    favoritesRepository = FakeFavoritesRepository();
    cubit = FavoritesCubit(
      authSessionCubit: authSessionCubit,
      favoritesRepository: favoritesRepository,
    );
  });

  tearDown(() async {
    await cubit.close();
    await authSessionCubit.close();
    await authRepository.close();
    await favoritesRepository.close();
  });

  test('starts with an empty list before authentication', () {
    expect(cubit.state, isA<FavoritesSuccess>());
    expect(successOf(cubit).favorites, isEmpty);
  });

  test('loads favorites after the user authenticates', () async {
    authRepository.controller.add(Success(testUser));
    await pumpEventQueue();

    favoritesRepository.emit([testFavorite(id: 'f1'), testFavorite(id: 'f2')]);
    await pumpEventQueue();

    final state = successOf(cubit);
    expect(state.favorites.length, 2);
    expect(state.isFavorite('f1'), isTrue);
    expect(state.isFavorite('missing'), isFalse);
  });

  test('toggleFavorite adds a food that is not a favorite', () async {
    authRepository.controller.add(Success(testUser));
    await pumpEventQueue();

    await cubit.toggleFavorite(testFood(id: 'f1'));
    await pumpEventQueue();

    expect(favoritesRepository.addedIds, ['f1']);
    expect(successOf(cubit).isFavorite('f1'), isTrue);
  });

  test('toggleFavorite removes a food that is already a favorite', () async {
    authRepository.controller.add(Success(testUser));
    await pumpEventQueue();
    favoritesRepository.emit([testFavorite(id: 'f1')]);
    await pumpEventQueue();

    await cubit.toggleFavorite(testFood(id: 'f1'));
    await pumpEventQueue();

    expect(favoritesRepository.removedIds, ['f1']);
    expect(successOf(cubit).isFavorite('f1'), isFalse);
  });

  test('selection mode selects and deselects favorites', () async {
    authRepository.controller.add(Success(testUser));
    await pumpEventQueue();
    favoritesRepository.emit([testFavorite(id: 'f1'), testFavorite(id: 'f2')]);
    await pumpEventQueue();

    cubit.enterSelectionMode();
    expect(successOf(cubit).isSelectionMode, isTrue);

    cubit.toggleSelection('f1');
    expect(successOf(cubit).selectedIds, {'f1'});

    cubit.toggleSelection('f1');
    expect(successOf(cubit).selectedIds, isEmpty);

    cubit.exitSelectionMode();
    expect(successOf(cubit).isSelectionMode, isFalse);
  });

  test('enterSelectionMode is ignored when there are no favorites', () async {
    authRepository.controller.add(Success(testUser));
    await pumpEventQueue();
    favoritesRepository.emit([]);
    await pumpEventQueue();

    cubit.enterSelectionMode();

    expect(successOf(cubit).isSelectionMode, isFalse);
  });

  test('deleteSelected removes the selected favorites and exits selection', () async {
    authRepository.controller.add(Success(testUser));
    await pumpEventQueue();
    favoritesRepository.emit([
      testFavorite(id: 'f1'),
      testFavorite(id: 'f2'),
      testFavorite(id: 'f3'),
    ]);
    await pumpEventQueue();

    cubit.enterSelectionMode();
    cubit.toggleSelection('f1');
    cubit.toggleSelection('f2');
    await cubit.deleteSelected();
    await pumpEventQueue();

    expect(favoritesRepository.removedBatches, hasLength(1));
    expect(favoritesRepository.removedBatches.first, containsAll(['f1', 'f2']));

    final state = successOf(cubit);
    expect(state.favorites.map((f) => f.id), ['f3']);
    expect(state.isSelectionMode, isFalse);
  });

  test('logging out clears the favorites list', () async {
    authRepository.controller.add(Success(testUser));
    await pumpEventQueue();
    favoritesRepository.emit([testFavorite(id: 'f1')]);
    await pumpEventQueue();

    authRepository.controller.add(const Success(null));
    await pumpEventQueue();

    expect(successOf(cubit).favorites, isEmpty);
  });

  test('stream errors emit a failure and retry re-subscribes', () async {
    authRepository.controller.add(Success(testUser));
    await pumpEventQueue();

    favoritesRepository.emitError(const UnknownFailure());
    await pumpEventQueue();

    expect(cubit.state, isA<FavoritesFailure>());

    cubit.retry();
    await pumpEventQueue();
    favoritesRepository.emit([testFavorite(id: 'f1')]);
    await pumpEventQueue();

    final state = successOf(cubit);
    expect(state.favorites.single.id, 'f1');
  });
}