import 'dart:async';
import 'dart:io';

import 'package:bite_go/core/constants/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'failure.dart';

class FirebaseErrorMapper {
  const FirebaseErrorMapper._();

  static Failure map(Object error) {
    if (error is FirebaseException) {
      return switch (error.code) {
        'invalid-credential' ||
        'wrong-password' ||
        'invalid-email' => const InvalidCredentialsFailure(),
        'email-already-in-use' => const EmailAlreadyExistsFailure(),
        'user-not-found' => const UserNotFoundFailure(),
        'too-many-requests' => const TooManyRequestsFailure(),
        'network-request-failed' => const NetworkFailure(),
        'canceled' => const CancelledFailure(),
        // Preserve Google Sign-In / provider misconfiguration details so they
        // are not replaced by a generic unknown-error string.
        'clientConfigurationError' ||
        'providerConfigurationError' =>
          UnknownFailure(_messageOrUnknown(error.message)),
        _ => const UnknownFailure(),
      };
    }
    if (error is TimeoutException) {
      return const TimeoutFailure();
    }
    if (error is SocketException) {
      return const NetworkFailure();
    }
    return const UnknownFailure();
  }

  static String _messageOrUnknown(String? message) {
    final trimmed = message?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return AppStrings.unknownError;
    }
    return trimmed;
  }
}
