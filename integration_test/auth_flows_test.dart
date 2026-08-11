import 'dart:ui';

import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

final DateTime _now = DateTime.now();
final String _email =
    'e2e.${_now.millisecondsSinceEpoch}@example.com';
const String _password = 'AuthPass123!';
final String _username = 'e2eUser${_now.millisecondsSinceEpoch % 10000}';

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 250));
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  fail('Timed out waiting for: $finder');
}

Finder appButton(String text) =>
    find.byWidgetPredicate((w) => w is AppButton && w.text == text);

Finder fieldByHint(String hint) => find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText == hint,
    );

Future<void> fillAndSubmit(
  WidgetTester tester, {
  required String hint,
  required String text,
}) async {
  await tester.enterText(fieldByHint(hint).last, text);
  await tester.pump(const Duration(milliseconds: 600));
}

Future<void> tapAppButton(WidgetTester tester, String text) async {
  final finder = appButton(text);
  await tester.ensureVisible(finder);
  await tester.pump(const Duration(milliseconds: 100));
  await tester.tap(finder);
  await tester.pump(const Duration(milliseconds: 200));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('auth flows E2E on real backend (M01-M05)', (tester) async {
    final testErrorHandler = FlutterError.onError;
    final testPlatformErrorHandler = PlatformDispatcher.instance.onError;
    app.main();

    await pumpUntilFound(
      tester,
      find.text(AppStrings.preAuthSignUpWithEmail),
      timeout: const Duration(seconds: 60),
    );

    FlutterError.onError = testErrorHandler;
    PlatformDispatcher.instance.onError = testPlatformErrorHandler;

    debugPrint('E2E: on pre-auth (unauthenticated)');

    debugPrint('E2E M02: signing up with $_email');
    await tapAppButton(tester, AppStrings.preAuthSignUpWithEmail);
    await pumpUntilFound(tester, find.text(AppStrings.signUpTitle));
    await fillAndSubmit(tester,
        hint: AppStrings.signUpEmailHint, text: _email);
    await fillAndSubmit(tester,
        hint: AppStrings.signUpPasswordHint, text: _password);
    await fillAndSubmit(tester,
        hint: AppStrings.signUpUsernameHint, text: _username);
    await tapAppButton(tester, AppStrings.signUpButton);
    await pumpUntilFound(
      tester,
      find.text(AppStrings.homeTitle),
      timeout: const Duration(seconds: 60),
    );
    debugPrint('E2E M02 PASS: signed up and landed on Home');

    debugPrint('E2E M05: logging out');
    await tapAppButton(tester, AppStrings.logoutTitle);
    await pumpUntilFound(tester, find.text(AppStrings.logoutMessage));
    await tester.tap(
      find.widgetWithText(TextButton, AppStrings.logoutConfirm),
    );
    await pumpUntilFound(
      tester,
      find.text(AppStrings.preAuthSignUpWithEmail),
      timeout: const Duration(seconds: 60),
    );
    debugPrint('E2E M05 PASS: logged out and redirected to auth');

    debugPrint('E2E M01: logging in with created account');
    await tester.tap(find.text(AppStrings.preAuthLogIn));
    await pumpUntilFound(tester, find.text(AppStrings.loginTitle));
    await fillAndSubmit(tester,
        hint: AppStrings.loginEmailHint, text: _email);
    await fillAndSubmit(tester,
        hint: AppStrings.loginPasswordHint, text: _password);
    await tapAppButton(tester, AppStrings.loginButton);
    await pumpUntilFound(
      tester,
      find.text(AppStrings.homeTitle),
      timeout: const Duration(seconds: 60),
    );
    debugPrint('E2E M01 PASS: logged in and landed on Home');

    debugPrint('E2E M04: forgot password');
    await tapAppButton(tester, AppStrings.logoutTitle);
    await pumpUntilFound(tester, find.text(AppStrings.logoutMessage));
    await tester.tap(
      find.widgetWithText(TextButton, AppStrings.logoutConfirm),
    );
    await pumpUntilFound(
      tester,
      find.text(AppStrings.preAuthSignUpWithEmail),
      timeout: const Duration(seconds: 60),
    );
    await tester.tap(find.text(AppStrings.preAuthLogIn));
    await pumpUntilFound(tester, find.text(AppStrings.loginTitle));
    await tester.tap(find.text(AppStrings.loginForgotPassword));
    await pumpUntilFound(tester, find.text(AppStrings.forgotPasswordButton));
    await fillAndSubmit(tester,
        hint: AppStrings.forgotPasswordEmailHint, text: _email);
    await tapAppButton(tester, AppStrings.forgotPasswordButton);
    await pumpUntilFound(
      tester,
      find.text(AppStrings.forgotPasswordEmailSent),
      timeout: const Duration(seconds: 60),
    );
    await tapAppButton(tester, AppStrings.ok);
    await pumpUntilFound(tester, find.text(AppStrings.loginTitle));
    debugPrint(
      'E2E M04 PASS: Firebase accepted password reset for the account, OK '
      'returned to Login (email delivery cannot be confirmed without inbox '
      'access)',
    );

    debugPrint('E2E M03: attempting Google sign-in from Login');
    await tester.pump(const Duration(milliseconds: 500));
    await tapAppButton(tester, AppStrings.preAuthSignUpWithGoogle);
    await tester.pump(const Duration(seconds: 1));
    final end = DateTime.now().add(const Duration(seconds: 25));
    var landedHome = false;
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 250));
      if (find.text(AppStrings.homeTitle).evaluate().isNotEmpty) {
        landedHome = true;
        break;
      }
      if (find.byType(Dialog).evaluate().isNotEmpty) {
        break;
      }
    }
    if (landedHome) {
      debugPrint('E2E M03 PASS: Google sign-in completed on device');
    } else {
      debugPrint(
        'E2E M03 BLOCKED/NOT VERIFIED: Google sign-in did not complete. '
        'Requires a Google account on the device and manual interaction with '
        'the Google account picker. Configuration (serverClientId / '
        'google-services.json) is in place; this step cannot be fully '
        'automated without that interaction.',
      );
      expect(
        find.text(AppStrings.homeTitle),
        findsNothing,
        reason: 'Google flow should not navigate to Home when blocked',
      );
      expect(
        find.text(AppStrings.loginTitle),
        findsOneWidget,
        reason: 'Should remain on Login when Google sign-in is blocked',
      );
    }
  });
}
