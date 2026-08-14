import 'package:bite_go/core/logging/app_logger.dart';
import 'package:bite_go/core/services/local_storage.dart';
import 'package:bite_go/features/cart/data/models/cart_item.dart';
import 'package:bite_go/features/cart/presentation/cubit/cart_state.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({
    required LocalStorage localStorage,
    required AppLogger appLogger,
  })  : _localStorage = localStorage,
        _appLogger = appLogger,
        super(const CartLoading()) {
    loadData();
  }

  final LocalStorage _localStorage;
  final AppLogger _appLogger;

  Future<void> loadData() async {
    final items = await Future<List<CartItem>>(() => _loadItems());
    if (isClosed || state is! CartLoading) {
      return;
    }
    emit(CartSuccess(items: items));
  }

  void addItem(FoodModel food, {int quantity = 1}) {
    final current = state;
    final items = current is CartSuccess ? [...current.items] : <CartItem>[];
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
    final current = state;
    if (current is! CartSuccess) {
      return;
    }
    final items = [...current.items];
    final index = items.indexWhere((item) => item.food.id == foodId);
    if (index < 0) {
      return;
    }
    items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    _emit(items);
  }

  void decrement(String foodId) {
    final current = state;
    if (current is! CartSuccess) {
      return;
    }
    final items = [...current.items];
    final index = items.indexWhere((item) => item.food.id == foodId);
    if (index < 0 || items[index].quantity <= 1) {
      return;
    }
    items[index] = items[index].copyWith(quantity: items[index].quantity - 1);
    _emit(items);
  }

  void removeItem(String foodId) {
    final current = state;
    if (current is! CartSuccess) {
      return;
    }
    final items = current.items
        .where((item) => item.food.id != foodId)
        .toList();
    _emit(items);
  }

  void _emit(List<CartItem> items) {
    emit(CartSuccess(items: items));
    _persist(items);
  }

  Future<void> _persist(List<CartItem> items) async {
    try {
      await _localStorage.write(
        LocalStorageKeys.cartItems,
        items.map((item) => item.toJson()).toList(),
      );
    } catch (error, stackTrace) {
      _appLogger.error(
        'CartCubit: failed to persist cart items',
        error: error,
        stackTrace: stackTrace,
        report: true,
      );
    }
  }

  List<CartItem> _loadItems() {
    try {
      final raw = _localStorage.read<List<dynamic>>(LocalStorageKeys.cartItems);
      if (raw == null) {
        return const [];
      }
      return raw
          .whereType<Map>()
          .map((entry) => CartItem.fromJson(Map<String, dynamic>.from(entry)))
          .toList();
    } catch (error, stackTrace) {
      _appLogger.error(
        'CartCubit: failed to load cart items',
        error: error,
        stackTrace: stackTrace,
        report: true,
      );
      return const [];
    }
  }
}
