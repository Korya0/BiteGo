import 'package:bite_go/core/common/app_empty_state.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:bite_go/features/cart/presentation/views/cart_view.dart';
import 'package:bite_go/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:bite_go/features/cart/presentation/widgets/cart_loading_view.dart';
import 'package:bite_go/features/cart/presentation/widgets/payment_summary_section.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../search/search_test_doubles.dart' show FakeLocalStorage;

void main() {
  late CartCubit cubit;

  final burger = FoodModel(
    id: 'burger',
    name: 'Ordinary Burgers',
    description: 'Juicy beef burger',
    imageUrl: '',
    price: 12000,
    rating: 4.9,
    categoryId: 'burger',
    isAvailable: true,
    sortOrder: 1,
  );

  setUp(() async {
    cubit = CartCubit(localStorage: FakeLocalStorage());
    await pumpEventQueue();
  });

  tearDown(() => cubit.close());

  Future<void> pumpCartView(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.cart,
      routes: [
        GoRoute(
          path: AppRoutes.cart,
          builder: (context, state) => const CartView(),
        ),
        GoRoute(
          path: AppRoutes.search,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Search route')),
          ),
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

  testWidgets('empty cart shows the empty state', (tester) async {
    await pumpCartView(tester);

    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.text(AppStrings.cartEmptyTitle), findsOneWidget);
    expect(find.text(AppStrings.cartEmptyMessage), findsOneWidget);
    expect(find.text(AppStrings.cartFindFoods), findsOneWidget);
    expect(find.byType(CartItemCard), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('loading state shows a skeleton mirroring the filled cart', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: CartLoadingView())),
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.bySubtype<Skeletonizer>(), findsOneWidget);
    expect(find.byType(CartItemCard), findsNWidgets(2));
    expect(find.byType(PaymentSummarySection), findsOneWidget);
    expect(find.text(AppStrings.cartOrderNow), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Find Foods navigates to the search screen', (tester) async {
    await pumpCartView(tester);

    await tester.tap(find.text(AppStrings.cartFindFoods));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Search route'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('filled cart shows items and payment summary', (tester) async {
    cubit.addItem(burger, quantity: 2);

    await pumpCartView(tester);

    expect(find.byType(AppEmptyState), findsNothing);
    expect(find.byType(CartItemCard), findsOneWidget);
    expect(find.text('Ordinary Burgers'), findsOneWidget);
    expect(find.byType(PaymentSummarySection), findsOneWidget);
    expect(find.text('${AppStrings.cartTotalItems} (2)'), findsOneWidget);
    expect(find.text('24k IQD'), findsNWidgets(2));
    expect(find.text(AppStrings.cartFree), findsOneWidget);
    expect(find.text(AppStrings.cartOrderNow), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('quantity controls update the cart', (tester) async {
    cubit.addItem(burger);

    await pumpCartView(tester);

    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('2'), findsOneWidget);
    expect(find.text('24k IQD'), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('removing the last item shows the empty state', (tester) async {
    cubit.addItem(burger);

    await pumpCartView(tester);

    await tester.tap(find.byIcon(Icons.delete_outline_rounded));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(CartItemCard), findsNothing);
    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.text(AppStrings.cartEmptyMessage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
