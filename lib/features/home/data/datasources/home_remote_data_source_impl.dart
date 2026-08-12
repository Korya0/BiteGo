import 'package:bite_go/features/home/data/datasources/home_remote_data_source.dart';
import 'package:bite_go/features/home/data/models/banner_model.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<List<BannerModel>> getBanners() async {
    final snapshot = await _firestore
        .collection('banners')
        .orderBy('sortOrder')
        .get();
    return snapshot.docs
        .map((doc) => BannerModel.fromFirestore(doc.data(), documentId: doc.id))
        .toList();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await _firestore
        .collection('categories')
        .orderBy('sortOrder')
        .get();
    return snapshot.docs
        .map(
          (doc) =>
              CategoryModel.fromFirestore(doc.data(), documentId: doc.id),
        )
        .toList();
  }

  @override
  Future<List<FoodModel>> getFoods() async {
    final snapshot = await _firestore
        .collection('foods')
        .orderBy('sortOrder')
        .get();
    return snapshot.docs
        .map(
          (doc) => FoodModel.fromFirestore(doc.data(), documentId: doc.id),
        )
        .toList();
  }
}
