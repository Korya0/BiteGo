import 'package:bite_go/core/services/local_storage.dart';
import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/search/presentation/cubit/search_cubit.dart';
import 'package:bite_go/features/search/presentation/cubit/search_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'search_test_doubles.dart';

Future<SearchSuccess> _loadSuccess(SearchCubit cubit) async {
  await cubit.loadData();
  return cubit.state as SearchSuccess;
}

void main() {
  late FakeLocalStorage localStorage;
  late FakeHomeRepository homeRepository;
  late SearchCubit cubit;

  setUp(() {
    localStorage = FakeLocalStorage();
    homeRepository = FakeHomeRepository(
      foodsResult: Success(testFoods),
      categoriesResult: Success(testCategories),
    );
    cubit = SearchCubit(
      homeRepository: homeRepository,
      localStorage: localStorage,
    );
  });

  tearDown(() => cubit.close());

  test('initial state is SearchInitial', () {
    expect(cubit.state, isA<SearchInitial>());
  });

  test('loadData emits SearchLoading then SearchSuccess with loaded data', () async {
    localStorage.store[LocalStorageKeys.recentSearches] = ['pizza'];
    final states = <SearchState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.loadData();
    await pumpEventQueue();

    await subscription.cancel();
    expect(states.first, isA<SearchLoading>());
    final success = states.last as SearchSuccess;
    expect(success.foods, testFoods);
    expect(success.categories, testCategories);
    expect(success.recentSearches, ['pizza']);
  });

  test('loadData emits SearchFailure when foods fail', () async {
    homeRepository.foodsResult = const Error(UnknownFailure());

    await cubit.loadData();

    expect(cubit.state, isA<SearchFailure>());
  });

  test('loadData emits SearchFailure when categories fail', () async {
    homeRepository.categoriesResult = const Error(UnknownFailure());

    await cubit.loadData();

    expect(cubit.state, isA<SearchFailure>());
  });

  test('queryChanged filters foods by name case-insensitively', () async {
    await _loadSuccess(cubit);

    cubit.queryChanged('pIzZa');

    final state = cubit.state as SearchSuccess;
    expect(state.filteredFoods.map((food) => food.id), ['f1']);
  });

  test('queryChanged filters foods by description', () async {
    await _loadSuccess(cubit);

    cubit.queryChanged('beef');

    final state = cubit.state as SearchSuccess;
    expect(state.filteredFoods.map((food) => food.id), ['f2']);
  });

  test('empty query returns all foods', () async {
    await _loadSuccess(cubit);

    cubit.queryChanged('   ');

    final state = cubit.state as SearchSuccess;
    expect(state.filteredFoods.length, testFoods.length);
  });

  test('selectCategory filters foods by category id', () async {
    await _loadSuccess(cubit);

    cubit.selectCategory('pizza');

    final state = cubit.state as SearchSuccess;
    expect(state.filteredFoods.map((food) => food.id), ['f1']);
  });

  test('selectCategory with null clears the category filter', () async {
    await _loadSuccess(cubit);

    cubit.selectCategory('burger');
    cubit.selectCategory(null);

    final state = cubit.state as SearchSuccess;
    expect(state.filteredFoods.length, testFoods.length);
  });

  test('submitQuery adds the query to the front of recent searches and persists', () async {
    final state = await _loadSuccess(cubit);

    cubit.queryChanged('pizza');
    cubit.submitQuery();

    final updated = cubit.state as SearchSuccess;
    expect(updated.recentSearches, ['pizza']);
    expect(localStorage.read<List<String>>(LocalStorageKeys.recentSearches), [
      'pizza',
    ]);
    expect(state.recentSearches, isEmpty);
  });

  test('submitQuery avoids duplicates and moves the existing term to the front', () async {
    localStorage.store[LocalStorageKeys.recentSearches] = ['burger', 'pizza'];
    await _loadSuccess(cubit);

    cubit.queryChanged('burger');
    cubit.submitQuery();

    final state = cubit.state as SearchSuccess;
    expect(state.recentSearches, ['burger', 'pizza']);
  });

  test('submitQuery ignores an empty query', () async {
    await _loadSuccess(cubit);

    cubit.queryChanged('   ');
    cubit.submitQuery();

    final state = cubit.state as SearchSuccess;
    expect(state.recentSearches, isEmpty);
    expect(localStorage.contains(LocalStorageKeys.recentSearches), isFalse);
  });

  test('submitQuery caps recent searches at five entries', () async {
    localStorage.store[LocalStorageKeys.recentSearches] = [
      'a',
      'b',
      'c',
      'd',
      'e',
    ];
    await _loadSuccess(cubit);

    cubit.queryChanged('f');
    cubit.submitQuery();

    final state = cubit.state as SearchSuccess;
    expect(state.recentSearches, ['f', 'a', 'b', 'c', 'd']);
  });

  test('deleteRecentSearch removes the term and persists', () async {
    localStorage.store[LocalStorageKeys.recentSearches] = ['pizza', 'burger'];
    await _loadSuccess(cubit);

    cubit.deleteRecentSearch('pizza');

    final state = cubit.state as SearchSuccess;
    expect(state.recentSearches, ['burger']);
    expect(localStorage.read<List<String>>(LocalStorageKeys.recentSearches), [
      'burger',
    ]);
  });

  test('clearRecentSearches empties recent searches and deletes from storage', () async {
    localStorage.store[LocalStorageKeys.recentSearches] = ['pizza'];
    await _loadSuccess(cubit);

    cubit.clearRecentSearches();

    final state = cubit.state as SearchSuccess;
    expect(state.recentSearches, isEmpty);
    expect(localStorage.contains(LocalStorageKeys.recentSearches), isFalse);
  });
}