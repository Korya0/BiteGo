import 'package:bite_go/core/services/local_storage.dart';
import 'package:bite_go/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:bite_go/features/cart/presentation/cubit/cart_state.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../search/search_test_doubles.dart' show FakeLocalStorage;

CartSuccess successOf(CartCubit cubit) => cubit.state as CartSuccess;

void main() {
  late FakeLocalStorage localStorage;
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
  final pizza = FoodModel(
    id: 'pizza',
    name: 'Margherita Pizza',
    description: 'Cheesy classic with basil',
    imageUrl: '',
    price: 10000,
    rating: 4.6,
    categoryId: 'pizza',
    isAvailable: true,
    sortOrder: 2,
  );

  setUp(() async {
    localStorage = FakeLocalStorage();
    cubit = CartCubit(localStorage: localStorage);
    await pumpEventQueue();
  });

  tearDown(() => cubit.close());

  test('starts loading then emits an empty success state', () {
    expect(cubit.state, isA<CartSuccess>());
    expect(successOf(cubit).items, isEmpty);
    expect(successOf(cubit).totalItems, 0);
    expect(successOf(cubit).total, 0);
  });

  test('addItem appends a new item', () {
    cubit.addItem(burger);

    expect(successOf(cubit).items.length, 1);
    expect(successOf(cubit).items.first.food.id, 'burger');
    expect(successOf(cubit).items.first.quantity, 1);
  });

  test('addItem merges quantity when the same food is added again', () {
    cubit.addItem(burger, quantity: 2);
    cubit.addItem(burger);

    expect(successOf(cubit).items.length, 1);
    expect(successOf(cubit).items.first.quantity, 3);
  });

  test('addItem works before the initial load completes', () {
    final fresh = CartCubit(localStorage: FakeLocalStorage());

    fresh.addItem(burger);

    expect(successOf(fresh).items.length, 1);
    expect(successOf(fresh).items.first.quantity, 1);

    fresh.close();
  });

  test('increment increases the item quantity', () {
    cubit.addItem(burger);

    cubit.increment('burger');

    expect(successOf(cubit).items.first.quantity, 2);
  });

  test('decrement decreases the item quantity and floors at one', () {
    cubit.addItem(burger, quantity: 3);

    cubit.decrement('burger');
    expect(successOf(cubit).items.first.quantity, 2);

    cubit.decrement('burger');
    cubit.decrement('burger');
    expect(successOf(cubit).items.first.quantity, 1);
  });

  test('removeItem removes only the matching item', () {
    cubit.addItem(burger);
    cubit.addItem(pizza);

    cubit.removeItem('burger');

    expect(successOf(cubit).items.length, 1);
    expect(successOf(cubit).items.first.food.id, 'pizza');
  });

  test('totals are calculated from the actual items', () {
    cubit.addItem(burger, quantity: 2);
    cubit.addItem(pizza);

    expect(successOf(cubit).totalItems, 3);
    expect(successOf(cubit).subtotal, 34000);
    expect(successOf(cubit).deliveryFee, 0);
    expect(successOf(cubit).total, 34000);
  });

  test('persists items to local storage on every change', () {
    cubit.addItem(burger);

    final stored = localStorage.read<List<dynamic>>(LocalStorageKeys.cartItems);
    expect(stored, isNotNull);
    expect(stored!.length, 1);
  });

  test('restores persisted items when the cubit is created', () async {
    cubit.addItem(burger, quantity: 2);
    cubit.close();

    final restored = CartCubit(localStorage: localStorage);
    await pumpEventQueue();

    expect(successOf(restored).items.length, 1);
    expect(successOf(restored).items.first.food.id, 'burger');
    expect(successOf(restored).items.first.quantity, 2);

    restored.close();
  });
}
