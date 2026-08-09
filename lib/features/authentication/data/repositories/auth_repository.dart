import 'dart:async';

import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';

abstract interface class AuthRepository {
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  });

  Future<Result<UserModel>> signUp({
    required String email,
    required String password,
    required String username,
  });

  Future<Result<UserModel>> signInWithGoogle();

  Future<Result<void>> sendPasswordResetEmail({
    required String email,
  });

  Stream<Result<UserModel?>> get authStateChanges;

  Future<Result<void>> logout();
}
