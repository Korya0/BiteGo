import 'dart:async';
import 'dart:io';

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
}
