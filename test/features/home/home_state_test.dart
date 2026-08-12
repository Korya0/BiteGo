import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:bite_go/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes.dart';

void main() {
  final pizza = FoodModel(
    id: 'f1',
    name: 'BBQ Chicken Pizza',
    description: 'desc',
    imageUrl: 'https://example.com/1.png',
    price: 20000,
    rating: 4.6,
    categoryId: 'pizza',
    isAvailable: true,
    sortOrder: 1,
  );
  final taco = FoodModel(
    id: 'f2',
    name: 'Chicken Taco',
    description: 'desc',
    imageUrl: 'https://example.com/2.png',
    price: 12000,
    rating: 4.2,
    categoryId: 'taco',
    isAvailable: true,
    sortOrder: 2,
  );

  group('HomeSuccess', () {
    HomeSuccess buildState({String? selectedCategoryId}) {
      return HomeSuccess(
        banners: [tBanner],
        categories: [tCategory],
        foods: [pizza, taco],
        selectedCategoryId: selectedCategoryId,
      );
    }

    test('returns all foods when no category is selected', () {
      expect(buildState().filteredFoods, [pizza, taco]);
    });

    test('returns only matching foods when a category is selected', () {
      final state = buildState(selectedCategoryId: 'pizza');
      expect(state.filteredFoods, [pizza]);
    });

    test('returns empty list when no foods match the selected category', () {
      final state = buildState(selectedCategoryId: 'burger');
      expect(state.filteredFoods, isEmpty);
    });

    test('copyWith updates only the provided fields', () {
      final state = buildState();
      final updated = state.copyWith(
        selectedCategoryId: () => 'taco',
      );

      expect(updated.selectedCategoryId, 'taco');
      expect(updated.banners, state.banners);
      expect(updated.categories, state.categories);
      expect(updated.foods, state.foods);
    });

    test('copyWith can reset the selected category to null', () {
      final state = buildState(selectedCategoryId: 'pizza');
      final updated = state.copyWith(selectedCategoryId: () => null);

      expect(updated.selectedCategoryId, isNull);
    });
  });
}
