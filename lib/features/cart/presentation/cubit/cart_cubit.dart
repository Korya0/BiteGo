import 'package:bite_go/core/services/local_storage.dart';
import 'package:bite_go/features/cart/data/models/cart_item.dart';
import 'package:bite_go/features/cart/presentation/cubit/cart_state.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({required LocalStorage localStorage})
      : _localStorage = localStorage,
        super(CartState(items: _loadItems(localStorage)));

  final LocalStorage _localStorage;

  static List<CartItem> _loadItems(LocalStorage localStorage) {
    final raw = localStorage.read<List<dynamic>>(LocalStorageKeys.cartItems);
    if (raw == null) {
      return const [];
    }
    return raw
        .whereType<Map>()
        .map((entry) => CartItem.fromJson(Map<String, dynamic>.from(entry)))
        .toList();
  }

  void addItem(FoodModel food, {int quantity = 1}) {
    final items = [...state.items];
    final index = items.indexWhere((item) => item.food.id == food.id);
    if (index >= 0) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + quantity,
      );
    } else {
      items.add(CartItem(food: food, quantity: quantity));
    }
    _emit(items);
  }

  void increment(String foodId) {
    final items = [...state.items];
    final index = items.indexWhere((item) => item.food.id == foodId);
    if (index < 0) {
      return;
    }
    items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    _emit(items);
  }

  void decrement(String foodId) {
    final items = [...state.items];
    final index = items.indexWhere((item) => item.food.id == foodId);
    if (index < 0 || items[index].quantity <= 1) {
      return;
    }
    items[index] = items[index].copyWith(quantity: items[index].quantity - 1);
    _emit(items);
  }

  void removeItem(String foodId) {
    final items = state.items
        .where((item) => item.food.id != foodId)
        .toList();
    _emit(items);
  }

  void _emit(List<CartItem> items) {
    emit(CartState(items: items));
    _localStorage.write(
      LocalStorageKeys.cartItems,
      items.map((item) => item.toJson()).toList(),
    );
  }
}
