import 'dart:async';

import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_text_divider.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/presentation/cubit/forgot_password_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/login_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/sign_up_cubit.dart';
import 'package:bite_go/features/authentication/presentation/views/forgot_password_view.dart';
import 'package:bite_go/features/authentication/presentation/views/login_view.dart';
import 'package:bite_go/features/authentication/presentation/views/sign_up_view.dart';
import 'package:bite_go/features/authentication/presentation/widgets/google_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/fakes.dart';

class _AuthViewsHarness {
  _AuthViewsHarness() {
    repository = FakeAuthRepository();
    loginCubit = LoginCubit(authRepository: repository);
    signUpCubit = SignUpCubit(authRepository: repository);
    forgotPasswordCubit = ForgotPasswordCubit(authRepository: repository);
    router = GoRouter(
      initialLocation: AppRoutes.authLogin,
      routes: [
        GoRoute(
          path: AppRoutes.authLogin,
          builder: (context, state) => BlocProvider.value(
            value: loginCubit,
            child: const LoginView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.authSignUp,
          builder: (context, state) => BlocProvider.value(
            value: signUpCubit,
            child: const SignUpView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.authForgotPassword,
          builder: (context, state) => BlocProvider.value(
            value: forgotPasswordCubit,
            child: const ForgotPasswordView(),
          ),
        ),
      ],
    );
  }

  late final FakeAuthRepository repository;
  late final LoginCubit loginCubit;
  late final SignUpCubit signUpCubit;
  late final ForgotPasswordCubit forgotPasswordCubit;
  late final GoRouter router;

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));
  }

  Future<void> pushForgotPassword(WidgetTester tester) async {
    router.push(AppRoutes.authForgotPassword);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
  }

  Future<void> dispose() async {
    if (!loginCubit.isClosed) {
      await loginCubit.close();
    }
    if (!signUpCubit.isClosed) {
      await signUpCubit.close();
    }
    if (!forgotPasswordCubit.isClosed) {
      await forgotPasswordCubit.close();
    }
    await repository.authStateChangesController.close();
  }
}

Finder appButtonWithText(String text) =>
    find.byWidgetPredicate((w) => w is AppButton && w.text == text);

Finder fieldByHint(String hint) => find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText == hint,
    );

Future<void> tapAppButton(
  WidgetTester tester,
  String text,
) async {
  final finder = appButtonWithText(text);
  await tester.ensureVisible(finder);
  await tester.pump(const Duration(milliseconds: 100));
  await tester.tap(finder);
  await tester.pump();
}

void main() {
  testWidgets('login view shows the shared Google button and no social '
      'buttons', (tester) async {
    final h = _AuthViewsHarness();
    addTearDown(h.dispose);
    await h.pump(tester);

    expect(find.byType(GoogleSignInButton), findsOneWidget);
    expect(find.text(AppStrings.preAuthSignUpWithGoogle), findsOneWidget);
    expect(find.text('Facebook'), findsNothing);
    expect(find.byType(AppTextDivider), findsOneWidget);
  });

  testWidgets('sign up view shows the shared Google button and no social '
      'buttons', (tester) async {
    final h = _AuthViewsHarness();
    addTearDown(h.dispose);
    await h.pump(tester);
    h.router.go(AppRoutes.authSignUp);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(GoogleSignInButton), findsOneWidget);
    expect(find.text(AppStrings.preAuthSignUpWithGoogle), findsOneWidget);
    expect(find.text('Facebook'), findsNothing);
    expect(find.byType(AppTextDivider), findsOneWidget);
  });

  testWidgets('login failure is shown as inline red text, not a dialog',
      (tester) async {
    final h = _AuthViewsHarness();
    addTearDown(h.dispose);
    h.repository.loginResult = const Error(InvalidCredentialsFailure());
    await h.pump(tester);

    await tester.enterText(
      fieldByHint(AppStrings.loginEmailHint),
      'user@example.com',
    );
    await tester.enterText(
      fieldByHint(AppStrings.loginPasswordHint),
      'AuthPass123!',
    );
    await tester.pump();
    await tapAppButton(tester, AppStrings.loginButton);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(Dialog), findsNothing);
    expect(find.text(AppStrings.invalidCredentialsError), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('sign up failure is shown as inline red text, not a dialog',
      (tester) async {
    final h = _AuthViewsHarness();
    addTearDown(h.dispose);
    h.repository.signUpResult = const Error(EmailAlreadyExistsFailure());
    await h.pump(tester);
    h.router.go(AppRoutes.authSignUp);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    await tester.enterText(
      fieldByHint(AppStrings.signUpEmailHint),
      'user@example.com',
    );
    await tester.enterText(
      fieldByHint(AppStrings.signUpPasswordHint),
      'AuthPass123!',
    );
    await tester.enterText(
      fieldByHint(AppStrings.signUpUsernameHint),
      'user1',
    );
    await tester.pump();
    await tapAppButton(tester, AppStrings.signUpButton);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(Dialog), findsNothing);
    expect(find.text(AppStrings.emailAlreadyInUseError), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('login button blocks duplicate submits and keeps a fixed '
      'loading indicator', (tester) async {
    final h = _AuthViewsHarness();
    addTearDown(h.dispose);
    final gate = Completer<void>();
    h.repository.loginResult = Success<UserModel>(tUser);
    h.repository.loginGate = gate;
    await h.pump(tester);

    await tester.enterText(
      fieldByHint(AppStrings.loginEmailHint),
      'user@example.com',
    );
    await tester.enterText(
      fieldByHint(AppStrings.loginPasswordHint),
      'AuthPass123!',
    );
    await tester.pump();
    await tapAppButton(tester, AppStrings.loginButton);

    expect(h.repository.loginCalls, 1);

    await tester.tap(appButtonWithText(AppStrings.loginButton),
        warnIfMissed: false);
    await tester.pump();
    expect(h.repository.loginCalls, 1);

    final spinner = find.descendant(
      of: appButtonWithText(AppStrings.loginButton),
      matching: find.byType(CircularProgressIndicator),
    );
    expect(spinner, findsOneWidget);
    expect(tester.getSize(spinner), const Size(20, 20));

    gate.complete();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('forgot password failure is shown as inline red text',
      (tester) async {
    final h = _AuthViewsHarness();
    addTearDown(h.dispose);
    h.repository.resetPasswordResult = const Error(UserNotFoundFailure());
    await h.pump(tester);
    await h.pushForgotPassword(tester);

    await tester.enterText(
      fieldByHint(AppStrings.forgotPasswordEmailHint),
      'user@example.com',
    );
    await tester.pump();
    await tapAppButton(tester, AppStrings.forgotPasswordButton);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(Dialog), findsNothing);
    expect(find.text(AppStrings.userNotFoundError), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('forgot password success shows a dialog and OK returns to '
      'Login', (tester) async {
    final h = _AuthViewsHarness();
    addTearDown(h.dispose);
    h.repository.resetPasswordResult = const Success<void>(null);
    await h.pump(tester);
    await h.pushForgotPassword(tester);

    await tester.enterText(
      fieldByHint(AppStrings.forgotPasswordEmailHint),
      'user@example.com',
    );
    await tester.pump();
    await tapAppButton(tester, AppStrings.forgotPasswordButton);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text(AppStrings.forgotPasswordEmailSent), findsOneWidget);

    await tapAppButton(tester, AppStrings.ok);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text(AppStrings.loginTitle), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
  });
}
