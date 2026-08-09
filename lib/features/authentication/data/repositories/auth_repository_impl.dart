import 'dart:async';

import 'package:bite_go/core/utils/firebase_error_mapper.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/data/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource authRemoteDataSource})
    : _authRemoteDataSource = authRemoteDataSource;

  final AuthRemoteDataSource _authRemoteDataSource;

  @override
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) {
    return _guard(
      () => _authRemoteDataSource.login(email: email, password: password),
    );
  }

  @override
  Future<Result<UserModel>> signUp({
    required String email,
    required String password,
    required String username,
  }) {
    return _guard(
      () => _authRemoteDataSource.signUp(
        email: email,
        password: password,
        username: username,
      ),
    );
  }

  @override
  Future<Result<UserModel>> signInWithGoogle() {
    return _guard(() => _authRemoteDataSource.signInWithGoogle());
  }

  @override
  Future<Result<void>> sendPasswordResetEmail({
    required String email,
  }) {
    return _guard(
      () => _authRemoteDataSource.sendPasswordResetEmail(email: email),
    );
  }

  @override
  Stream<Result<UserModel?>> get authStateChanges {
    return _authRemoteDataSource.authStateChanges
        .map(
          (user) => Success<UserModel?>(user),
        )
        .handleError(
          (Object error, StackTrace stackTrace) =>
              Error<UserModel?>(FirebaseErrorMapper.map(error)),
        );
  }

  @override
  Future<Result<void>> logout() {
    return _guard(_authRemoteDataSource.logout);
  }

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on Exception catch (error) {
      return Error(FirebaseErrorMapper.map(error));
    }
  }
}
