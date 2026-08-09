import 'dart:async';

import 'package:bite_go/core/di/app_injector.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_state.dart';
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

class _AuthSessionRouterRefresh extends ChangeNotifier {
  _AuthSessionRouterRefresh(AuthSessionCubit authSessionCubit) {
    _subscription = authSessionCubit.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthSessionState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  refreshListenable: _AuthSessionRouterRefresh(getIt<AuthSessionCubit>()),
  redirect: _redirectBasedOnAuthState,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Home')),
      ),
    ),
    GoRoute(
      path: AppRoutes.auth,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Pre-Authentication')),
      ),
    ),
    GoRoute(
      path: AppRoutes.authLogin,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Login')),
      ),
    ),
    GoRoute(
      path: AppRoutes.authSignUp,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Sign Up')),
      ),
    ),
    GoRoute(
      path: AppRoutes.authForgotPassword,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Forgot Password')),
      ),
    ),
  ],
);

String? _redirectBasedOnAuthState(BuildContext context, GoRouterState state) {
  final bool isOnSplash = state.matchedLocation == AppRoutes.splash;
  final bool isOnAuthRoute = _authRoutes.contains(state.matchedLocation);
  final bool isOnProtectedRoute = _protectedRoutes.contains(
    state.matchedLocation,
  );
  return switch (getIt<AuthSessionCubit>().state) {
    AuthSessionUnknown() => isOnSplash ? null : AppRoutes.splash,
    Unauthenticated() => isOnSplash || isOnProtectedRoute
        ? AppRoutes.auth
        : null,
    Authenticated() => isOnSplash || isOnAuthRoute ? AppRoutes.home : null,
  };
}
