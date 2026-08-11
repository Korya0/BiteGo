import 'dart:async';

import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/data/repositories/auth_repository.dart';
import 'package:bite_go/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

void main() {
  late FakeAuthRemoteDataSource dataSource;
  late FakeAppLogger logger;
  late AuthRepository repository;

  setUp(() {
    dataSource = FakeAuthRemoteDataSource();
    logger = FakeAppLogger();
    repository = AuthRepositoryImpl(
      authRemoteDataSource: dataSource,
      appLogger: logger,
    );
  });

  FirebaseException firebaseException(String code) {
    return FirebaseException(code: code, message: 'msg', plugin: 'test');
  }

  group('AuthRepositoryImpl.login', () {
    test('returns Success when the data source succeeds', () async {
      final result = await repository.login(
        email: 'user@example.com',
        password: 'Password1',
      );

      expect(result, isA<Success<UserModel>>());
      expect(dataSource.lastLoginEmail, 'user@example.com');
      expect(dataSource.lastLoginPassword, 'Password1');
      expect(logger.warnings, isEmpty);
      expect(logger.errors, isEmpty);
    });

    test('returns Error for expected Firebase failures', () async {
      dataSource.loginError = firebaseException('invalid-credential');

      final result = await repository.login(
        email: 'user@example.com',
        password: 'wrong',
      );

      expect(result, isA<Error<UserModel>>());
      final failure = (result as Error<UserModel>).failure;
      expect(failure, isA<InvalidCredentialsFailure>());
      expect(logger.warnings, hasLength(1));
      expect(logger.errors, isEmpty);
    });

    test('returns Error for cancellation', () async {
      dataSource.loginError = firebaseException('canceled');

      final result = await repository.login(
        email: 'user@example.com',
        password: 'Password1',
      );

      expect(result, isA<Error<UserModel>>());
      expect((result as Error<UserModel>).failure, isA<CancelledFailure>());
      expect(logger.warnings, hasLength(1));
      expect(logger.errors, isEmpty);
    });

    test('reports unknown failures as errors', () async {
      dataSource.loginError = Exception('boom');

      final result = await repository.login(
        email: 'user@example.com',
        password: 'Password1',
      );

      expect(result, isA<Error<UserModel>>());
      expect((result as Error<UserModel>).failure, isA<UnknownFailure>());
      expect(logger.errors, hasLength(1));
    });
  });

  group('AuthRepositoryImpl.signInWithGoogle', () {
    test('returns Success when the data source succeeds', () async {
      final result = await repository.signInWithGoogle();

      expect(result, isA<Success<UserModel>>());
      expect(dataSource.googleSignInCalls, 1);
    });

    test('returns Error for cancellation', () async {
      dataSource.googleSignInError = firebaseException('canceled');

      final result = await repository.signInWithGoogle();

      expect(result, isA<Error<UserModel>>());
      expect((result as Error<UserModel>).failure, isA<CancelledFailure>());
      expect(logger.warnings, hasLength(1));
      expect(logger.errors, isEmpty);
    });
  });

  group('AuthRepositoryImpl.sendPasswordResetEmail', () {
    test('returns Success when the data source succeeds', () async {
      final result = await repository.sendPasswordResetEmail(
        email: 'user@example.com',
      );

      expect(result, isA<Success<void>>());
      expect(dataSource.lastResetEmail, 'user@example.com');
    });

    test('returns Error for user-not-found', () async {
      dataSource.resetPasswordError = firebaseException('user-not-found');

      final result = await repository.sendPasswordResetEmail(
        email: 'missing@example.com',
      );

      expect(result, isA<Error<void>>());
      expect((result as Error<void>).failure, isA<UserNotFoundFailure>());
    });
  });

  group('AuthRepositoryImpl.logout', () {
    test('returns Success when the data source succeeds', () async {
      final result = await repository.logout();

      expect(result, isA<Success<void>>());
      expect(dataSource.logoutCalls, 1);
    });

    test('returns Error when the data source fails', () async {
      dataSource.logoutError = Exception('boom');

      final result = await repository.logout();

      expect(result, isA<Error<void>>());
      expect((result as Error<void>).failure, isA<UnknownFailure>());
      expect(logger.errors, hasLength(1));
    });
  });

  group('AuthRepositoryImpl.authStateChanges', () {
    test('maps data source stream values to Success results', () async {
      final repository = AuthRepositoryImpl(
        authRemoteDataSource: _StreamAuthRemoteDataSource(
          Stream<UserModel?>.fromIterable([tUser, null]),
        ),
        appLogger: logger,
      );

      final results = <Result<UserModel?>>[];
      final subscription = repository.authStateChanges.listen(results.add);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await subscription.cancel();

      expect(results, hasLength(2));
      expect(results[0], isA<Success<UserModel?>>());
      expect((results[0] as Success<UserModel?>).data?.uid, tUser.uid);
      expect(results[1], isA<Success<UserModel?>>());
      expect((results[1] as Success<UserModel?>).data, isNull);
    });
  });
}

class _StreamAuthRemoteDataSource implements AuthRemoteDataSource {
  _StreamAuthRemoteDataSource(this.authStateStream);

  final Stream<UserModel?> authStateStream;

  @override
  Stream<UserModel?> get authStateChanges => authStateStream;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signInWithGoogle() {
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }
}
