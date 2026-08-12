import 'package:bite_go/features/food_details/presentation/cubit/food_details_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes.dart';

void main() {
  late FoodDetailsCubit cubit;

  setUp(() {
    cubit = FoodDetailsCubit(food: tFood);
  });

  tearDown(() async {
    if (!cubit.isClosed) {
      await cubit.close();
    }
  });

  group('FoodDetailsCubit', () {
    test('starts with quantity 1', () {
      expect(cubit.state.quantity, 1);
    });

    test('increment increases the quantity', () {
      cubit.increment();

      expect(cubit.state.quantity, 2);
    });

    test('decrement decreases the quantity above 1', () {
      cubit.increment();
      cubit.increment();

      cubit.decrement();

      expect(cubit.state.quantity, 2);
    });

    test('decrement never goes below 1', () {
      cubit.decrement();

      expect(cubit.state.quantity, 1);
    });

    test('preserves the food across quantity changes', () {
      cubit.increment();
      cubit.increment();
      cubit.decrement();

      expect(cubit.state.food, tFood);
    });
  });
}
