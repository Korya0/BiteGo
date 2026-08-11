import 'dart:async';

import 'package:bite_go/core/di/app_injector.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_state.dart';
import 'package:bite_go/features/authentication/presentation/cubit/forgot_password_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/login_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/sign_up_cubit.dart';
import 'package:bite_go/features/authentication/presentation/views/forgot_password_view.dart';
import 'package:bite_go/features/authentication/presentation/views/login_view.dart';
import 'package:bite_go/features/authentication/presentation/views/pre_authentication_view.dart';
import 'package:bite_go/features/authentication/presentation/views/sign_up_view.dart';
import 'package:bite_go/features/home/presentation/views/home_view.dart';
import 'package:bite_go/features/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

final GoRouter appRouter = createAppRouter(getIt<AuthSessionCubit>());

GoRouter createAppRouter(
  AuthSessionCubit authSessionCubit, {
  LoginCubit Function()? loginCubitFactory,
  SignUpCubit Function()? signUpCubitFactory,
  ForgotPasswordCubit Function()? forgotPasswordCubitFactory,
}) {
  final routerRefresh = _RouterRefresh(authSessionCubit);
  final loginFactory = loginCubitFactory ?? () => getIt<LoginCubit>();
  final signUpFactory = signUpCubitFactory ?? () => getIt<SignUpCubit>();
  final forgotPasswordFactory =
      forgotPasswordCubitFactory ?? () => getIt<ForgotPasswordCubit>();
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: routerRefresh,
    redirect: (context, state) => _redirectBasedOnAuthState(
      context,
      state,
      routerRefresh,
      authSessionCubit,
    ),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => SplashView(
          onCompleted: routerRefresh.completeSplash,
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => BlocProvider(
          create: (context) => signUpFactory(),
          child: const PreAuthenticationView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.authLogin,
        builder: (context, state) => BlocProvider(
          create: (context) => loginFactory(),
          child: const LoginView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.authSignUp,
        builder: (context, state) => BlocProvider(
          create: (context) => signUpFactory(),
          child: const SignUpView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.authForgotPassword,
        builder: (context, state) => BlocProvider(
          create: (context) => forgotPasswordFactory(),
          child: const ForgotPasswordView(),
        ),
      ),
    ],
  );
}

String? _redirectBasedOnAuthState(
  BuildContext context,
  GoRouterState state,
  _RouterRefresh routerRefresh,
  AuthSessionCubit authSessionCubit,
) {
  return redirectBasedOnAuthState(
    sessionState: authSessionCubit.state,
    splashCompleted: routerRefresh.splashCompleted,
    location: state.matchedLocation,
  );
}

String? redirectBasedOnAuthState({
  required AuthSessionState sessionState,
  required bool splashCompleted,
  required String location,
}) {
  final bool isOnSplash = location == AppRoutes.splash;

  if (!splashCompleted) {
    return isOnSplash ? null : AppRoutes.splash;
  }

  final bool isOnAuthRoute = _authRoutes.contains(location);
  final bool isOnProtectedRoute = _protectedRoutes.contains(location);

  return switch (sessionState) {
    AuthSessionUnknown() => isOnSplash ? null : AppRoutes.splash,
    Unauthenticated() =>
      isOnSplash || isOnProtectedRoute ? AppRoutes.auth : null,
    Authenticated() => isOnSplash || isOnAuthRoute ? AppRoutes.home : null,
  };
}
