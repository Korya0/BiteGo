import 'package:bite_go/features/cart/data/models/cart_item.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class CartState {
  const CartState();
}

final class CartLoading extends CartState {
  const CartLoading();
}

final class CartSuccess extends CartState {
  const CartSuccess({required this.items});

  final List<CartItem> items;

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => 0;

  double get total => subtotal + deliveryFee;
}
