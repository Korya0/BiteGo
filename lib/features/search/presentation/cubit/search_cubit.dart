import 'package:bite_go/core/logging/app_logger.dart';
import 'package:bite_go/core/services/local_storage.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:bite_go/features/home/data/repositories/home_repository.dart';
import 'package:bite_go/features/search/presentation/cubit/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required HomeRepository homeRepository,
    required LocalStorage localStorage,
    required AppLogger appLogger,
  })  : _homeRepository = homeRepository,
        _localStorage = localStorage,
        _appLogger = appLogger,
        super(const SearchInitial());

  static const int _maxRecentSearches = 5;

  final HomeRepository _homeRepository;
  final LocalStorage _localStorage;
  final AppLogger _appLogger;

  Future<void> loadData() async {
    if (state is SearchLoading) {
      return;
    }
    emit(const SearchLoading());

    final results = await Future.wait([
      _homeRepository.getFoods(),
      _homeRepository.getCategories(),
    ]);

    if (isClosed) {
      return;
    }

    final foodsResult = results[0] as Result<List<FoodModel>>;
    final categoriesResult = results[1] as Result<List<CategoryModel>>;

    if (foodsResult is Error<List<FoodModel>>) {
      emit(SearchFailure(foodsResult.failure));
      return;
    }
    if (categoriesResult is Error<List<CategoryModel>>) {
      emit(SearchFailure(categoriesResult.failure));
      return;
    }

    emit(
      SearchSuccess(
        foods: (foodsResult as Success<List<FoodModel>>).data,
        categories: (categoriesResult as Success<List<CategoryModel>>).data,
        query: '',
        selectedCategoryId: null,
        recentSearches: _loadRecentSearches(),
      ),
    );
  }

  void queryChanged(String query) {
    final current = state;
    if (current is! SearchSuccess) {
      return;
    }
    emit(current.copyWith(query: query));
  }

  void submitQuery() {
    final current = state;
    if (current is! SearchSuccess) {
      return;
    }
    final trimmedQuery = current.query.trim();
    if (trimmedQuery.isEmpty) {
      return;
    }
    final updated = _prependRecentSearch(current.recentSearches, trimmedQuery);
    _persistRecentSearches(updated);
    emit(current.copyWith(recentSearches: updated));
  }

  void selectCategory(String? categoryId) {
    final current = state;
    if (current is! SearchSuccess) {
      return;
    }
    emit(current.copyWith(selectedCategoryId: () => categoryId));
  }

  void deleteRecentSearch(String term) {
    final current = state;
    if (current is! SearchSuccess) {
      return;
    }
    final updated = current.recentSearches
        .where((search) => search != term)
        .toList();
    _persistRecentSearches(updated);
    emit(current.copyWith(recentSearches: updated));
  }

  void clearRecentSearches() {
    final current = state;
    if (current is! SearchSuccess) {
      return;
    }
    _deleteRecentSearches();
    emit(current.copyWith(recentSearches: const []));
  }

  List<String> _loadRecentSearches() {
    try {
      return _localStorage.read<List<String>>(LocalStorageKeys.recentSearches) ??
          const [];
    } catch (error, stackTrace) {
      _appLogger.error(
        'SearchCubit: failed to load recent searches',
        error: error,
        stackTrace: stackTrace,
        report: true,
      );
      return const [];
    }
  }

  List<String> _prependRecentSearch(List<String> current, String query) {
    final filtered = current.where((search) => search != query).toList();
    return [query, ...filtered].take(_maxRecentSearches).toList();
  }

  void _persistRecentSearches(List<String> searches) {
    _localStorage.write(LocalStorageKeys.recentSearches, searches).catchError(
      (Object error, StackTrace stackTrace) {
        _appLogger.error(
          'SearchCubit: failed to persist recent searches',
          error: error,
          stackTrace: stackTrace,
          report: true,
        );
      },
    );
  }

  void _deleteRecentSearches() {
    _localStorage.delete(LocalStorageKeys.recentSearches).catchError(
      (Object error, StackTrace stackTrace) {
        _appLogger.error(
          'SearchCubit: failed to clear recent searches',
          error: error,
          stackTrace: stackTrace,
          report: true,
        );
      },
    );
  }
}