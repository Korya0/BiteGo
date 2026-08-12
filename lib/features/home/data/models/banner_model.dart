import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  BannerModel({
    required this.id,
    required this.imageUrl,
    required this.sortOrder,
  });

  factory BannerModel.fromFirestore(
    Map<String, dynamic> data, {
    required String documentId,
  }) {
    return BannerModel(
      id: documentId,
      imageUrl: data['imageUrl'] as String? ?? '',
      sortOrder: data['sortOrder'] as int? ?? 0,
    );
  }

  final String id;
  final String imageUrl;
  final int sortOrder;

  static Future<List<BannerModel>> fetchAll(
    FirebaseFirestore firestore,
  ) async {
    final snapshot = await firestore
        .collection('banners')
        .orderBy('sortOrder')
        .get();
    return snapshot.docs
        .map((doc) => BannerModel.fromFirestore(doc.data(), documentId: doc.id))
        .toList();
  }
}
