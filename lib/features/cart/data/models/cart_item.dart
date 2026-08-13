import 'package:bite_go/features/home/data/models/food_model.dart';

class CartItem {
  const CartItem({required this.food, required this.quantity});

  final FoodModel food;
  final int quantity;

  double get totalPrice => food.price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(food: food, quantity: quantity ?? this.quantity);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': food.id,
      'name': food.name,
      'description': food.description,
      'imageUrl': food.imageUrl,
      'price': food.price,
      'rating': food.rating,
      'categoryId': food.categoryId,
      'isAvailable': food.isAvailable,
      'sortOrder': food.sortOrder,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      food: FoodModel(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        categoryId: json['categoryId'] as String? ?? '',
        isAvailable: json['isAvailable'] as bool? ?? true,
        sortOrder: json['sortOrder'] as int? ?? 0,
      ),
      quantity: json['quantity'] as int? ?? 1,
    );
  }
}
