import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteModel {
  const FavoriteModel({required this.food, required this.addedAt});

  factory FavoriteModel.fromFood(FoodModel food) {
    return FavoriteModel(food: food, addedAt: DateTime.now());
  }

  factory FavoriteModel.fromFirestore(
    Map<String, dynamic> data, {
    required String documentId,
  }) {
    return FavoriteModel(
      food: FoodModel.fromFirestore(data, documentId: documentId),
      addedAt: (data['addedAt'] as Timestamp).toDate(),
    );
  }

  final FoodModel food;
  final DateTime addedAt;

  String get id => food.id;

  Map<String, dynamic> toFirestoreMap() {
    return {
      'name': food.name,
      'description': food.description,
      'imageUrl': food.imageUrl,
      'price': food.price,
      'rating': food.rating,
      'categoryId': food.categoryId,
      'isAvailable': food.isAvailable,
      'sortOrder': food.sortOrder,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }
}