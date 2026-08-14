import 'package:bite_go/core/common/app_dialog.dart';
import 'package:bite_go/core/common/app_empty_state.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_cubit.dart';
import 'package:bite_go/features/favorites/data/models/favorite_model.dart';
import 'package:bite_go/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:bite_go/features/favorites/presentation/views/favorites_view.dart';
import 'package:bite_go/features/favorites/presentation/widgets/favorite_food_card.dart';
import 'package:bite_go/features/favorites/presentation/widgets/favorites_loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'favorites_test_doubles.dart';

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

  Future<void> authenticate(WidgetTester tester) async {
    await tester.runAsync(() async {
      authRepository.controller.add(Success(testUser));
      await pumpEventQueue();
    });
    await tester.pump();
  }

  Future<void> emitFavorites(
    WidgetTester tester,
    List<FavoriteModel> favorites,
  ) async {
    favoritesRepository.emit(favorites);
    await tester.pump();
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.runAsync(() async {
      await pumpEventQueue();
    });
    await tester.pump();
  }

  Future<void> pumpFavoritesView(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.favorites,
      routes: [
        GoRoute(
          path: AppRoutes.favorites,
          builder: (context, state) => const FavoritesView(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Home route'))),
        ),
      ],
    );
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('empty favorites shows the empty state', (tester) async {
    await authenticate(tester);
    await emitFavorites(tester, []);
    await pumpFavoritesView(tester);

    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.text(AppStrings.favoritesEmptyTitle), findsOneWidget);
    expect(find.text(AppStrings.favoritesEmptyMessage), findsOneWidget);
    expect(find.text(AppStrings.favoritesBrowseFoods), findsOneWidget);
    expect(find.byType(FavoriteFoodCard), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('initial state shows a skeleton mirroring the filled grid', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: FavoritesLoadingView())),
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.bySubtype<Skeletonizer>(), findsOneWidget);
    expect(find.byType(FavoriteFoodCard), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('favorites list shows cards and a select action', (tester) async {
    await authenticate(tester);
    await emitFavorites(tester, [
      testFavorite(id: 'f1', name: 'Margherita Pizza'),
      testFavorite(id: 'f2', name: 'Ordinary Burgers'),
    ]);
    await pumpFavoritesView(tester);

    expect(find.text(AppStrings.favoritesTitle), findsOneWidget);
    expect(find.byType(FavoriteFoodCard), findsNWidgets(2));
    expect(find.text('Margherita Pizza'), findsOneWidget);
    expect(find.text('Ordinary Burgers'), findsOneWidget);
    expect(find.byIcon(Icons.checklist_rounded), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline_rounded), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selection mode shows a count and allows selecting cards', (
    tester,
  ) async {
    await authenticate(tester);
    await emitFavorites(tester, [
      testFavorite(id: 'f1', name: 'Margherita Pizza'),
      testFavorite(id: 'f2', name: 'Ordinary Burgers'),
    ]);
    await pumpFavoritesView(tester);

    await tester.tap(find.byIcon(Icons.checklist_rounded));
    await tester.pump();

    expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    expect(find.text('0 ${AppStrings.favoritesSelectedCount}'), findsOneWidget);

    await tester.tap(find.byType(FavoriteFoodCard).at(0));
    await tester.pump();
    expect(find.text('1 ${AppStrings.favoritesSelectedCount}'), findsOneWidget);

    await tester.tap(find.byType(FavoriteFoodCard).at(1));
    await tester.pump();
    expect(find.text('2 ${AppStrings.favoritesSelectedCount}'), findsOneWidget);

    expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('deleting a single selected favorite does not ask for confirmation', (
    tester,
  ) async {
    await authenticate(tester);
    await emitFavorites(tester, [
      testFavorite(id: 'f1', name: 'Margherita Pizza'),
      testFavorite(id: 'f2', name: 'Ordinary Burgers'),
    ]);
    await pumpFavoritesView(tester);

    await tester.tap(find.byIcon(Icons.checklist_rounded));
    await tester.pump();
    await tester.tap(find.byType(FavoriteFoodCard).at(0));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.delete_outline_rounded));
    await settle(tester);

    expect(find.byType(AppDialog), findsNothing);
    expect(find.byType(FavoriteFoodCard), findsOneWidget);
    expect(find.text('Ordinary Burgers'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('deleting multiple favorites shows an info dialog then deletes', (
    tester,
  ) async {
    await authenticate(tester);
    await emitFavorites(tester, [
      testFavorite(id: 'f1', name: 'Margherita Pizza'),
      testFavorite(id: 'f2', name: 'Ordinary Burgers'),
      testFavorite(id: 'f3', name: 'Veggie Taco'),
    ]);
    await pumpFavoritesView(tester);

    await tester.tap(find.byIcon(Icons.checklist_rounded));
    await tester.pump();
    await tester.tap(find.byType(FavoriteFoodCard).at(0));
    await tester.pump();
    await tester.tap(find.byType(FavoriteFoodCard).at(1));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.delete_outline_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.text(AppStrings.favoritesRemoveConfirmMessage),
      findsOneWidget,
    );
    expect(find.text(AppStrings.ok), findsOneWidget);
    expect(find.text(AppStrings.favoritesDelete), findsNothing);
    expect(find.text(AppStrings.logoutCancel), findsNothing);

    await tester.tap(find.text(AppStrings.ok));
    await settle(tester);

    expect(find.byType(FavoriteFoodCard), findsOneWidget);
    expect(find.text('Veggie Taco'), findsOneWidget);
    expect(find.text('Margherita Pizza'), findsNothing);
    expect(favoritesRepository.removedBatches, [
      ['f1', 'f2'],
    ]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dismissing the info dialog still deletes the selected favorites', (
    tester,
  ) async {
    await authenticate(tester);
    await emitFavorites(tester, [
      testFavorite(id: 'f1', name: 'Margherita Pizza'),
      testFavorite(id: 'f2', name: 'Ordinary Burgers'),
    ]);
    await pumpFavoritesView(tester);

    await tester.tap(find.byIcon(Icons.checklist_rounded));
    await tester.pump();
    await tester.tap(find.byType(FavoriteFoodCard).at(0));
    await tester.pump();
    await tester.tap(find.byType(FavoriteFoodCard).at(1));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.delete_outline_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tapAt(const Offset(5, 5));
    await settle(tester);

    expect(find.byType(FavoriteFoodCard), findsNothing);
    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(favoritesRepository.removedBatches, [
      ['f1', 'f2'],
    ]);
    expect(tester.takeException(), isNull);
  });
}