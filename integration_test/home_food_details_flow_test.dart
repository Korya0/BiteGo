import 'dart:ui';

import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/features/home/presentation/widgets/food_card.dart';
import 'package:bite_go/features/home/presentation/widgets/home_category_chips.dart';
import 'package:bite_go/features/food_details/presentation/widgets/quantity_control.dart';
import 'package:bite_go/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

final DateTime _now = DateTime.now();
final String _email =
    'home.${_now.millisecondsSinceEpoch}@example.com';
const String _password = 'HomePass123!';
final String _username = 'homeUser${_now.millisecondsSinceEpoch % 10000}';

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 250));
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  fail('Timed out waiting for: $finder');
}

Finder appButton(String text) =>
    find.byWidgetPredicate((w) => w is AppButton && w.text == text);

Finder fieldByHint(String hint) => find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText == hint,
    );

Future<void> fillAndSubmit(
  WidgetTester tester, {
  required String hint,
  required String text,
}) async {
  await tester.enterText(fieldByHint(hint).last, text);
  await tester.pump(const Duration(milliseconds: 600));
}

Future<void> tapAppButton(WidgetTester tester, String text) async {
  final finder = appButton(text);
  await tester.ensureVisible(finder);
  await tester.pump(const Duration(milliseconds: 100));
  await tester.tap(finder);
  await tester.pump(const Duration(milliseconds: 200));
}

Finder quantityText(String value) => find.descendant(
      of: find.byType(QuantityControl),
      matching: find.text(value),
    );

Finder addToCartButton() => find.byWidgetPredicate(
      (w) =>
          w is AppButton &&
          (w.text == AppStrings.foodDetailsAddToCart ||
              w.text.startsWith('${AppStrings.foodDetailsAddToCart} —')),
    );

Finder chipText(String label) => find.descendant(
      of: find.byType(HomeCategoryChips),
      matching: find.text(label),
    );

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('home and food details E2E on real backend', (tester) async {
    final testErrorHandler = FlutterError.onError;
    final testPlatformErrorHandler = PlatformDispatcher.instance.onError;
    app.main();

    await pumpUntilFound(
      tester,
      find.text(AppStrings.preAuthSignUpWithEmail),
      timeout: const Duration(seconds: 60),
    );

    FlutterError.onError = testErrorHandler;
    PlatformDispatcher.instance.onError = testPlatformErrorHandler;

    debugPrint('E2E HOME: signing up with $_email');
    await tapAppButton(tester, AppStrings.preAuthSignUpWithEmail);
    await pumpUntilFound(tester, find.text(AppStrings.signUpTitle));
    await fillAndSubmit(
        tester, hint: AppStrings.signUpEmailHint, text: _email);
    await fillAndSubmit(
        tester, hint: AppStrings.signUpPasswordHint, text: _password);
    await fillAndSubmit(
        tester, hint: AppStrings.signUpUsernameHint, text: _username);
    await tapAppButton(tester, AppStrings.signUpButton);
    await pumpUntilFound(
      tester,
      find.text(AppStrings.homeTitle),
      timeout: const Duration(seconds: 60),
    );

    debugPrint('E2E HOME M10: waiting for home data from Firestore');
    await pumpUntilFound(
      tester,
      find.text(AppStrings.homeSectionPopularFoods),
      timeout: const Duration(seconds: 60),
    );
    await pumpUntilFound(
      tester,
      find.byType(FoodCard),
      timeout: const Duration(seconds: 60),
    );
    expect(find.text(AppStrings.homeGreeting), findsOneWidget);
    expect(find.text(_username), findsOneWidget);
    expect(find.byType(FoodCard), findsWidgets);
    debugPrint('E2E HOME M10 PASS: banners/categories/foods rendered');

    debugPrint('E2E HOME M11: bottom navigation tabs');
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    await tester.tap(find.text('Orders'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Orders'), findsNWidgets(2));

    await tester.tap(find.text('Cart'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Cart'), findsNWidgets(2));

    await tester.tap(find.text('Home'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text(AppStrings.homeSectionPopularFoods), findsOneWidget);
    expect(find.byType(FoodCard), findsWidgets);
    debugPrint('E2E HOME M11 PASS: nav tabs switch and Home retains data');

    debugPrint('E2E HOME M12: category filtering');
    final categoryTexts = tester
        .widgetList<Text>(find.descendant(
          of: find.byType(HomeCategoryChips),
          matching: find.byType(Text),
        ))
        .map((t) => t.data)
        .whereType<String>()
        .toList();
    expect(categoryTexts.first, 'All');
    final realCategories = categoryTexts.skip(1).toList();
    debugPrint('E2E HOME M12: categories loaded $realCategories');

    if (realCategories.isNotEmpty) {
      final firstCategory = realCategories.first;
      final beforeCategories = tester
          .widgetList<FoodCard>(find.byType(FoodCard))
          .map((card) => card.food.categoryId)
          .toSet();
      await tester.tap(chipText(firstCategory));
      await tester.pump(const Duration(milliseconds: 500));
      final afterCategories = tester
          .widgetList<FoodCard>(find.byType(FoodCard))
          .map((card) => card.food.categoryId)
          .toSet();
      expect(
        afterCategories.length,
        lessThanOrEqualTo(1),
        reason: 'after filtering, visible foods must belong to a single category',
      );
      debugPrint(
        'E2E HOME M12 PASS: category "$firstCategory" filtered, '
        'visible categories before=$beforeCategories after=$afterCategories',
      );

      await tester.tap(chipText('All'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(FoodCard), findsWidgets);
    } else {
      debugPrint(
        'E2E HOME M12 PASS: no categories in Firestore, only "All" chip shown',
      );
    }

    debugPrint('E2E HOME M13: opening food details');
    final foodName = tester
        .widget<Text>(find.descendant(
          of: find.byType(FoodCard).first,
          matching: find.byType(Text),
        ).first)
        .data;
    debugPrint('E2E HOME M13: first food is "$foodName"');
    await tester.tap(find.byType(FoodCard).first);
    await pumpUntilFound(
      tester,
      find.text(foodName!),
      timeout: const Duration(seconds: 30),
    );
    await pumpUntilFound(tester, find.text(AppStrings.foodDetailsQuantity));
    expect(addToCartButton(), findsOneWidget);
    expect(find.textContaining('IQD'), findsWidgets);
    debugPrint('E2E HOME M13 PASS: food details rendered');

    debugPrint('E2E HOME M14: quantity controls');
    expect(quantityText('1'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump(const Duration(milliseconds: 300));
    expect(quantityText('3'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pump(const Duration(milliseconds: 300));
    expect(quantityText('1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pump(const Duration(milliseconds: 300));
    expect(quantityText('1'), findsOneWidget);
    debugPrint('E2E HOME M14 PASS: quantity min 1 and +/- work');

    debugPrint('E2E HOME M15: add to cart');
    await tester.ensureVisible(addToCartButton());
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(addToCartButton());
    await pumpUntilFound(
      tester,
      find.textContaining('added to cart!'),
      timeout: const Duration(seconds: 30),
    );
    debugPrint('E2E HOME M15 PASS: add to cart feedback shown');

    debugPrint('E2E HOME M16: navigating back to home');
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await pumpUntilFound(
      tester,
      find.byType(FoodCard),
      timeout: const Duration(seconds: 30),
    );
    expect(find.text(AppStrings.homeSectionPopularFoods), findsOneWidget);
    debugPrint('E2E HOME M16 PASS: back on home with food grid');
  });
}
