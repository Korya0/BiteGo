import 'dart:async';

import 'package:bite_go/core/common/bottom_nav_bar/bottom_nav_tabs.dart';
import 'package:bite_go/core/common/bottom_nav_bar/main_view.dart';
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
import 'package:bite_go/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:bite_go/features/cart/presentation/views/cart_view.dart';
import 'package:bite_go/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:bite_go/features/favorites/presentation/views/favorites_view.dart';
import 'package:bite_go/features/home/presentation/cubit/home_cubit.dart';
import 'package:bite_go/features/home/presentation/views/home_view.dart';
import 'package:bite_go/features/profile/profile_view.dart';
import 'package:bite_go/features/search/presentation/cubit/search_cubit.dart';
import 'package:bite_go/features/search/presentation/views/search_view.dart';
import 'package:bite_go/features/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final Set<String> _protectedRoutes = {
  for (final tab in bottomNavTabs) tab.path,
  AppRoutes.favorites,
};

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
  HomeCubit Function()? homeCubitFactory,
  SearchCubit Function()? searchCubitFactory,
}) {
  final routerRefresh = _RouterRefresh(authSessionCubit);
  final loginFactory = loginCubitFactory ?? () => getIt<LoginCubit>();
  final signUpFactory = signUpCubitFactory ?? () => getIt<SignUpCubit>();
  final forgotPasswordFactory =
      forgotPasswordCubitFactory ?? () => getIt<ForgotPasswordCubit>();
  final homeFactory = homeCubitFactory ?? () => getIt<HomeCubit>();
  final searchFactory = searchCubitFactory ?? () => getIt<SearchCubit>();
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainView(navigationShell: navigationShell),
        branches: [
          for (final tab in bottomNavTabs)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: tab.path,
                  builder: (context, state) =>
                      _buildTabPage(context, tab.path, homeFactory),
                ),
              ],
            ),
        ],
      ),
      GoRoute(
        path: AppRoutes.search,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );
          },
          child: BlocProvider(
            create: (context) => searchFactory()..loadData(),
            child: const SearchView(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.favorites,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );
          },
          child: BlocProvider(
            create: (context) => getIt<FavoritesCubit>(),
            child: const FavoritesView(),
          ),
        ),
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

Widget _buildTabPage(
  BuildContext context,
  String path,
  HomeCubit Function() homeFactory,
) {
  return switch (path) {
    AppRoutes.home => BlocProvider(
      create: (context) => homeFactory()..loadHomeData(),
      child: const HomeView(),
    ),
    AppRoutes.cart => BlocProvider.value(
      value: getIt<CartCubit>(),
      child: const CartView(),
    ),
    AppRoutes.profile => const ProfileView(),
    _ => throw ArgumentError.value(
      path,
      'path',
      'No page registered for bottom nav tab',
    ),
  };
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
