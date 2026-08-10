import 'dart:async';

import 'package:bite_go/core/di/app_injector.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_state.dart';
import 'package:bite_go/features/authentication/presentation/views/forgot_password_view.dart';
import 'package:bite_go/features/authentication/presentation/views/login_view.dart';
import 'package:bite_go/features/authentication/presentation/views/pre_authentication_view.dart';
import 'package:bite_go/features/authentication/presentation/views/sign_up_view.dart';
import 'package:bite_go/features/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const Set<String> _protectedRoutes = {AppRoutes.home};

const Set<String> _authRoutes = {
  AppRoutes.auth,
  AppRoutes.authLogin,
  AppRoutes.authSignUp,
  AppRoutes.authForgotPassword,
};

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(AuthSessionCubit authSessionCubit) {
    _subscription = authSessionCubit.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthSessionState> _subscription;

  bool splashCompleted = false;

  void completeSplash() {
    splashCompleted = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final _routerRefresh = _RouterRefresh(getIt<AuthSessionCubit>());

GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  refreshListenable: _routerRefresh,
  redirect: _redirectBasedOnAuthState,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => SplashView(
        onCompleted: _routerRefresh.completeSplash,
      ),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Home')),
      ),
    ),
    GoRoute(
      path: AppRoutes.auth,
      builder: (context, state) => const PreAuthenticationView(),
    ),
    GoRoute(
      path: AppRoutes.authLogin,
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: AppRoutes.authSignUp,
      builder: (context, state) => const SignUpView(),
    ),
    GoRoute(
      path: AppRoutes.authForgotPassword,
      builder: (context, state) => const ForgotPasswordView(),
    ),
  ],
);

String? _redirectBasedOnAuthState(BuildContext context, GoRouterState state) {
  final bool isOnSplash = state.matchedLocation == AppRoutes.splash;

  // لو الـ splash لسه مخلصتش، افضل عليها
  if (!_routerRefresh.splashCompleted) {
    return isOnSplash ? null : AppRoutes.splash;
  }

  final bool isOnAuthRoute = _authRoutes.contains(state.matchedLocation);
  final bool isOnProtectedRoute = _protectedRoutes.contains(
    state.matchedLocation,
  );

  return switch (getIt<AuthSessionCubit>().state) {
    AuthSessionUnknown() => isOnSplash ? null : AppRoutes.splash,
    Unauthenticated() =>
      isOnSplash || isOnProtectedRoute ? AppRoutes.auth : null,
    Authenticated() => isOnSplash || isOnAuthRoute ? AppRoutes.home : null,
  };
}
