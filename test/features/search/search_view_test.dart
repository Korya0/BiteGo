import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/core/services/local_storage.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/home/presentation/widgets/home_success_view/food_card.dart';
import 'package:bite_go/features/search/presentation/cubit/search_cubit.dart';
import 'package:bite_go/features/search/presentation/views/search_view.dart';
import 'package:bite_go/features/search/presentation/widgets/empty_search_result.dart';
import 'package:bite_go/features/search/presentation/widgets/search_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'search_test_doubles.dart';

void main() {
  late FakeHomeRepository homeRepository;
  late FakeLocalStorage localStorage;

  setUp(() {
    homeRepository = FakeHomeRepository(
      foodsResult: Success(testFoods),
      categoriesResult: Success(testCategories),
    );
    localStorage = FakeLocalStorage();
  });

  Future<void> pumpSearchView(
    WidgetTester tester, {
    List<String> recentSearches = const [],
  }) async {
    localStorage.store[LocalStorageKeys.recentSearches] = recentSearches;
    final router = GoRouter(
      initialLocation: AppRoutes.search,
      routes: [
        GoRoute(
          path: AppRoutes.search,
          builder: (context, state) => const SearchView(),
        ),
      ],
    );
    await tester.pumpWidget(
      BlocProvider(
        create: (context) =>
            SearchCubit(homeRepository: homeRepository, localStorage: localStorage)
              ..loadData(),
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('renders app bar, search section, recent searches and orders', (
    tester,
  ) async {
    await pumpSearchView(tester, recentSearches: ['pizza']);
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text(AppStrings.searchTitle), findsWidgets);
    expect(find.byType(SearchSection), findsOneWidget);
    expect(find.text(AppStrings.searchRecentSearches), findsOneWidget);
    expect(find.text('pizza'), findsOneWidget);
    expect(find.text(AppStrings.searchMyRecentOrders), findsOneWidget);
    expect(find.text('Ordinary Burgers'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('typing a query shows matching food results', (tester) async {
    await pumpSearchView(tester);

    await tester.enterText(find.byType(TextField), 'burger');
    await tester.pump();

    expect(find.byType(FoodCard), findsOneWidget);
    expect(find.text('Ordinary Burgers'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unmatched query shows the empty search result state', (
    tester,
  ) async {
    await pumpSearchView(tester);

    await tester.enterText(find.byType(TextField), 'xyzzy');
    await tester.pump();
    await tester.pump();

    expect(find.byType(EmptySearchResult), findsOneWidget);
    expect(find.text(AppStrings.searchEmptyResult), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('loading state shows skeleton with static content, no spinner', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: AppRoutes.search,
      routes: [
        GoRoute(
          path: AppRoutes.search,
          builder: (context, state) => const SearchView(),
        ),
      ],
    );
    await tester.pumpWidget(
      BlocProvider(
        create: (context) =>
            SearchCubit(homeRepository: HangingHomeRepository(), localStorage: localStorage)
              ..loadData(),
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.bySubtype<Skeletonizer>(), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(SearchSection), findsOneWidget);
    expect(find.text(AppStrings.searchMyRecentOrders), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}