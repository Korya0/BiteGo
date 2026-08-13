import 'package:bite_go/core/services/local_storage.dart';
import 'package:bite_go/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../search/search_test_doubles.dart' show FakeLocalStorage;

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

  setUp(() {
    localStorage = FakeLocalStorage();
    cubit = CartCubit(localStorage: localStorage);
  });

  tearDown(() => cubit.close());

  test('starts with an empty cart', () {
    expect(cubit.state.items, isEmpty);
    expect(cubit.state.totalItems, 0);
    expect(cubit.state.total, 0);
  });

  test('addItem appends a new item', () {
    cubit.addItem(burger);

    expect(cubit.state.items.length, 1);
    expect(cubit.state.items.first.food.id, 'burger');
    expect(cubit.state.items.first.quantity, 1);
  });

  test('addItem merges quantity when the same food is added again', () {
    cubit.addItem(burger, quantity: 2);
    cubit.addItem(burger);

    expect(cubit.state.items.length, 1);
    expect(cubit.state.items.first.quantity, 3);
  });

  test('increment increases the item quantity', () {
    cubit.addItem(burger);

    cubit.increment('burger');

    expect(cubit.state.items.first.quantity, 2);
  });

  test('decrement decreases the item quantity and floors at one', () {
    cubit.addItem(burger, quantity: 3);

    cubit.decrement('burger');
    expect(cubit.state.items.first.quantity, 2);

    cubit.decrement('burger');
    cubit.decrement('burger');
    expect(cubit.state.items.first.quantity, 1);
  });

  test('removeItem removes only the matching item', () {
    cubit.addItem(burger);
    cubit.addItem(pizza);

    cubit.removeItem('burger');

    expect(cubit.state.items.length, 1);
    expect(cubit.state.items.first.food.id, 'pizza');
  });

  test('totals are calculated from the actual items', () {
    cubit.addItem(burger, quantity: 2);
    cubit.addItem(pizza);

    expect(cubit.state.totalItems, 3);
    expect(cubit.state.subtotal, 34000);
    expect(cubit.state.deliveryFee, 0);
    expect(cubit.state.total, 34000);
  });

  test('persists items to local storage on every change', () {
    cubit.addItem(burger);

    final stored = localStorage.read<List<dynamic>>(LocalStorageKeys.cartItems);
    expect(stored, isNotNull);
    expect(stored!.length, 1);
  });

  test('restores persisted items when the cubit is created', () {
    cubit.addItem(burger, quantity: 2);
    cubit.close();

    final restored = CartCubit(localStorage: localStorage);

    expect(restored.state.items.length, 1);
    expect(restored.state.items.first.food.id, 'burger');
    expect(restored.state.items.first.quantity, 2);

    restored.close();
  });
}
