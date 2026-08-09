import 'dart:async';

import 'package:bite_go/core/logging/app_logger.dart';
import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/firebase_error_mapper.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/data/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource authRemoteDataSource,
    required AppLogger appLogger,
  })  : _authRemoteDataSource = authRemoteDataSource,
        _appLogger = appLogger;

  final AuthRemoteDataSource _authRemoteDataSource;

  final AppLogger _appLogger;

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
              Error<UserModel?>(_handleFailure(error, stackTrace)),
        );
  }

  @override
  Future<Result<void>> logout() {
    return _guard(_authRemoteDataSource.logout);
  }

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on Exception catch (error, stackTrace) {
      return Error(_handleFailure(error, stackTrace));
    }
  }

  Failure _handleFailure(Object error, StackTrace stackTrace) {
    final failure = FirebaseErrorMapper.map(error);
    if (failure is UnknownFailure) {
      _appLogger.error(
        'AuthRepository: unexpected failure ${failure.runtimeType}',
        error: error,
        stackTrace: stackTrace,
        report: true,
      );
    } else {
      _appLogger.warning(
        'AuthRepository: expected failure ${failure.runtimeType} ($error)',
      );
    }
    return failure;
  }
}
