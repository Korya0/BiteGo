import 'dart:async';

import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/core/routes/app_router.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/forgot_password_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/login_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/fakes.dart';

class _AuthRouterHarness {
  _AuthRouterHarness() {
    controller = StreamController<Result<UserModel?>>();
    repository = FakeAuthRepository(authStateChangesController: controller);
    cubit = AuthSessionCubit(
      authRepository: repository,
      errorReporter: FakeErrorReporter(),
    );
    router = createAppRouter(
      cubit,
      loginCubitFactory: () => LoginCubit(authRepository: repository),
      signUpCubitFactory: () => SignUpCubit(authRepository: repository),
      forgotPasswordCubitFactory: () =>
          ForgotPasswordCubit(authRepository: repository),
    );
  }

  late final StreamController<Result<UserModel?>> controller;
  late final FakeAuthRepository repository;
  late final AuthSessionCubit cubit;
  late final GoRouter router;

  String currentPath() => router.routerDelegate.currentConfiguration.uri.path;

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(seconds: 2));
  }

  Future<void> emit(WidgetTester tester, Result<UserModel?> result) async {
    controller.add(result);
    await tester.pump();
    await tester.pump();
  }

  Future<void> disposeTree(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  Future<void> runWithHarness(
    WidgetTester tester,
    Future<void> Function(_AuthRouterHarness h) body,
  ) async {
    final h = _AuthRouterHarness();
    addTearDown(() async {
      if (!h.cubit.isClosed) {
        await h.cubit.close();
      }
      await h.controller.close();
    });
    await body(h);
  }

  testWidgets('unauthenticated startup redirects from splash to /auth',
      (tester) async {
    await runWithHarness(tester, (h) async {
      await h.pumpApp(tester);
      expect(h.currentPath(), AppRoutes.splash);

      await h.emit(tester, const Success<UserModel?>(null));

      expect(h.currentPath(), AppRoutes.auth);
      await h.disposeTree(tester);
    });
  });

  testWidgets('unauthenticated deep link to /home redirects to /auth',
      (tester) async {
    await runWithHarness(tester, (h) async {
      await h.pumpApp(tester);
      await h.emit(tester, const Success<UserModel?>(null));
      expect(h.currentPath(), AppRoutes.auth);

      h.router.go(AppRoutes.home);
      await tester.pump();
      await tester.pump();

      expect(h.currentPath(), AppRoutes.auth);
      await h.disposeTree(tester);
    });
  });

  testWidgets('authenticated deep link to auth route redirects to /home',
      (tester) async {
    await runWithHarness(tester, (h) async {
      await h.pumpApp(tester);
      await h.emit(tester, Success<UserModel?>(tUser));
      expect(h.currentPath(), AppRoutes.home);

      h.router.go(AppRoutes.authLogin);
      await tester.pump();
      await tester.pump();

      expect(h.currentPath(), AppRoutes.home);
      await h.disposeTree(tester);
    });
  });

  testWidgets('logout transition redirects to /auth', (tester) async {
    await runWithHarness(tester, (h) async {
      await h.pumpApp(tester);
      await h.emit(tester, Success<UserModel?>(tUser));
      expect(h.currentPath(), AppRoutes.home);

      h.repository.logoutResult = const Success<void>(null);
      await h.cubit.logout();
      await h.emit(tester, const Success<UserModel?>(null));

      expect(h.currentPath(), AppRoutes.auth);
      expect(h.repository.logoutCalls, 1);
      await h.disposeTree(tester);
    });
  });
}
