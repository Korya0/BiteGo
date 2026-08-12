import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  BannerModel({
    required this.id,
    required this.imageUrl,
    required this.sortOrder,
    this.badge = '',
    this.title = '',
    this.subtitle = '',
    this.isActive = true,
  });

  factory BannerModel.fromFirestore(
    Map<String, dynamic> data, {
    required String documentId,
  }) {
    return BannerModel(
      id: documentId,
      imageUrl: data['imageUrl'] as String? ?? '',
      sortOrder: data['sortOrder'] as int? ?? 0,
      badge: data['badge'] as String? ?? '',
      title: data['title'] as String? ?? '',
      subtitle: data['subtitle'] as String? ?? '',
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  final String id;
  final String imageUrl;
  final int sortOrder;
  final String badge;
  final String title;
  final String subtitle;
  final bool isActive;

  static Future<List<BannerModel>> fetchAll(
    FirebaseFirestore firestore,
  ) async {
    final snapshot = await firestore
        .collection('banners')
        .orderBy('sortOrder')
        .get();
    return snapshot.docs
        .map((doc) => BannerModel.fromFirestore(doc.data(), documentId: doc.id))
        .where((banner) => banner.isActive)
        .toList();
  }
}
