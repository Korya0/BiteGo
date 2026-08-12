import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/core/routes/app_router.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final authenticated = Authenticated(
    UserModel(
      uid: 'u1',
      email: 'user@example.com',
      username: 'user1',
      createdAt: DateTime.utc(2024, 1, 1),
    ),
  );
  const unauthenticated = Unauthenticated();
  const unknown = AuthSessionUnknown();

  group('redirectBasedOnAuthState', () {
    group('before splash completes', () {
      test('stays on splash', () {
        expect(
          redirectBasedOnAuthState(
            sessionState: unknown,
            splashCompleted: false,
            location: AppRoutes.splash,
          ),
          isNull,
        );
      });

      test('redirects every other route to splash', () {
        for (final location in [
          AppRoutes.home,
          AppRoutes.auth,
          AppRoutes.authLogin,
          AppRoutes.authSignUp,
          AppRoutes.authForgotPassword,
        ]) {
          expect(
            redirectBasedOnAuthState(
              sessionState: unknown,
              splashCompleted: false,
              location: location,
            ),
            AppRoutes.splash,
            reason: 'location $location',
          );
        }
      });
    });

    group('after splash completes with unknown state', () {
      test('stays on splash', () {
        expect(
          redirectBasedOnAuthState(
            sessionState: unknown,
            splashCompleted: true,
            location: AppRoutes.splash,
          ),
          isNull,
        );
      });

      test('redirects non-splash routes to splash', () {
        expect(
          redirectBasedOnAuthState(
            sessionState: unknown,
            splashCompleted: true,
            location: AppRoutes.home,
          ),
          AppRoutes.splash,
        );
      });
    });

    group('unauthenticated', () {
      test('allows auth routes', () {
        for (final location in [
          AppRoutes.auth,
          AppRoutes.authLogin,
          AppRoutes.authSignUp,
          AppRoutes.authForgotPassword,
        ]) {
          expect(
            redirectBasedOnAuthState(
              sessionState: unauthenticated,
              splashCompleted: true,
              location: location,
            ),
            isNull,
            reason: 'location $location',
          );
        }
      });

      test('redirects splash to auth', () {
        expect(
          redirectBasedOnAuthState(
            sessionState: unauthenticated,
            splashCompleted: true,
            location: AppRoutes.splash,
          ),
          AppRoutes.auth,
        );
      });

      test('redirects protected routes to auth (deep link guard)', () {
        for (final location in [
          AppRoutes.home,
          AppRoutes.foodDetails,
        ]) {
          expect(
            redirectBasedOnAuthState(
              sessionState: unauthenticated,
              splashCompleted: true,
              location: location,
            ),
            AppRoutes.auth,
            reason: 'location $location',
          );
        }
      });
    });

    group('authenticated', () {
      test('allows home', () {
        expect(
          redirectBasedOnAuthState(
            sessionState: authenticated,
            splashCompleted: true,
            location: AppRoutes.home,
          ),
          isNull,
        );
      });

      test('redirects splash to home', () {
        expect(
          redirectBasedOnAuthState(
            sessionState: authenticated,
            splashCompleted: true,
            location: AppRoutes.splash,
          ),
          AppRoutes.home,
        );
      });

      test('redirects auth routes to home (deep link guard)', () {
        for (final location in [
          AppRoutes.auth,
          AppRoutes.authLogin,
          AppRoutes.authSignUp,
          AppRoutes.authForgotPassword,
        ]) {
          expect(
            redirectBasedOnAuthState(
              sessionState: authenticated,
              splashCompleted: true,
              location: location,
            ),
            AppRoutes.home,
            reason: 'location $location',
          );
        }
      });
    });
  });
}
