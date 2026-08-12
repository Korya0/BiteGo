class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.sortOrder,
  });

  factory CategoryModel.fromFirestore(
    Map<String, dynamic> data, {
    required String documentId,
  }) {
    return CategoryModel(
      id: documentId,
      name: data['name'] as String? ?? '',
      sortOrder: data['sortOrder'] as int? ?? 0,
    );
  }

  final String id;
  final String name;
  final int sortOrder;
}
