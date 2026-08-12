class FoodModel {
  FoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.categoryId,
    required this.isAvailable,
    required this.sortOrder,
  });

  factory FoodModel.fromFirestore(
    Map<String, dynamic> data, {
    required String documentId,
  }) {
    return FoodModel(
      id: documentId,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      categoryId: data['categoryId'] as String? ?? '',
      isAvailable: data['isAvailable'] as bool? ?? true,
      sortOrder: data['sortOrder'] as int? ?? 0,
    );
  }

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double rating;
  final String categoryId;
  final bool isAvailable;
  final int sortOrder;
}
