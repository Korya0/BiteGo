import 'dart:async';

import 'package:bite_go/core/di/app_injector.dart';
import 'package:bite_go/core/routes/app_router.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/data/repositories/auth_repository.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  final StreamController<Result<UserModel?>> controller =
      StreamController<Result<UserModel?>>(sync: true);

  @override
  Stream<Result<UserModel?>> get authStateChanges => controller.stream;

  @override
  Future<Result<void>> logout() async => const Success(null);

  @override
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) =>
      throw UnimplementedError();

  @override
  Future<Result<UserModel>> signUp({
    required String email,
    required String password,
    required String username,
  }) =>
      throw UnimplementedError();

  @override
  Future<Result<UserModel>> signInWithGoogle() => throw UnimplementedError();

  @override
  Future<Result<void>> sendPasswordResetEmail({required String email}) =>
      throw UnimplementedError();
}

void main() {
  late _FakeAuthRepository repository;
  late AuthSessionCubit authSessionCubit;

  setUp(() async {
    await getIt.reset();
    repository = _FakeAuthRepository();
    authSessionCubit = AuthSessionCubit(authRepository: repository);
    getIt.registerSingleton<AuthSessionCubit>(authSessionCubit);
  });

  tearDown(() async {
    await authSessionCubit.close();
    await repository.controller.close();
    await getIt.reset();
  });

  testWidgets('startup destinations and auth guard redirect matrix', (
    tester,
  ) async {
    final router = appRouter;
    String location() =>
        router.routerDelegate.currentConfiguration.uri.toString();

    Future<void> emitAuthState(Result<UserModel?> result) async {
      repository.controller.add(result);
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 1)),
      );
      await tester.pumpAndSettle();
    }

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();

    final user = UserModel(
      uid: 'uid-1',
      email: 'user@bitego.com',
      username: 'tester',
      createdAt: DateTime(2024),
    );

    expect(location(), AppRoutes.splash);

    router.go(AppRoutes.home);
    await tester.pump();
    expect(location(), AppRoutes.splash);

    router.go(AppRoutes.authLogin);
    await tester.pump();
    expect(location(), AppRoutes.splash);

    await emitAuthState(const Success<UserModel?>(null));
    expect(location(), AppRoutes.auth);

    router.go(AppRoutes.home);
    await tester.pump();
    expect(location(), AppRoutes.auth);

    router.go(AppRoutes.auth);
    await tester.pump();
    expect(location(), AppRoutes.auth);

    await emitAuthState(Success<UserModel?>(user));
    expect(location(), AppRoutes.home);

    router.go(AppRoutes.home);
    await tester.pump();
    expect(location(), AppRoutes.home);

    await emitAuthState(const Success<UserModel?>(null));
    expect(location(), AppRoutes.auth);

    router.go(AppRoutes.splash);
    await tester.pump();
    expect(location(), AppRoutes.auth);

    await emitAuthState(Success<UserModel?>(user));
    expect(location(), AppRoutes.home);

    router.go(AppRoutes.splash);
    await tester.pump();
    expect(location(), AppRoutes.home);
  });
}
