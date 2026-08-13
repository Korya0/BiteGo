class OrderModel {
  const OrderModel({
    required this.imageUrl,
    required this.name,
    required this.restaurantName,
    required this.rating,
    required this.distanceMeters,
  });

  final String imageUrl;
  final String name;
  final String restaurantName;
  final double rating;
  final int distanceMeters;

  String get distanceLabel {
    if (distanceMeters >= 1000) {
      final km = distanceMeters / 1000;
      return '${km.toStringAsFixed(km % 1 == 0 ? 0 : 1)}km';
    }
    return '${distanceMeters}m';
  }

  static const List<OrderModel> recentOrders = [
    OrderModel(
      imageUrl: 'https://res.cloudinary.com/bu0ku10t/image/upload/v1786497548/Pizza_4.png',
      name: 'Ordinary Burgers',
      restaurantName: 'Burger Restaurant',
      rating: 4.9,
      distanceMeters: 190,
    ),
    OrderModel(
      imageUrl: 'https://res.cloudinary.com/bu0ku10t/image/upload/v1786497548/Pizza_4.png',
      name: 'Crispy Chicken',
      restaurantName: 'Burger Restaurant',
      rating: 4.7,
      distanceMeters: 220,
    ),
    OrderModel(
      imageUrl: 'https://res.cloudinary.com/bu0ku10t/image/upload/v1786497548/Pizza_4.png',
      name: 'Margherita Pizza',
      restaurantName: 'Pizza House',
      rating: 4.6,
      distanceMeters: 300,
    ),
  ];
}