import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  const UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.photoUrl,
    required this.createdAt,
  });

  final String uid;

  final String email;

  final String username;

  final String? photoUrl;

  final DateTime createdAt;

  factory UserModel.fromFirestore(
    Map<String, dynamic> map, {
    required String documentId,
  }) {
    return UserModel(
      uid: documentId,
      email: map['email'] as String,
      username: map['username'] as String,
      photoUrl: map['photoUrl'] as String?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'username': username,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
