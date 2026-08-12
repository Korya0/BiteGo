import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:flutter/foundation.dart';

@immutable
class FoodDetailsState {
  const FoodDetailsState({
    required this.food,
    this.quantity = 1,
  });

  final FoodModel food;
  final int quantity;

  FoodDetailsState copyWith({int? quantity}) {
    return FoodDetailsState(
      food: food,
      quantity: quantity ?? this.quantity,
    );
  }
}
