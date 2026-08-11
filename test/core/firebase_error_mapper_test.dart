import 'dart:async';
import 'dart:io';

import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/firebase_error_mapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirebaseErrorMapper.map', () {
    FirebaseException firebaseException(String code) {
      return FirebaseException(code: code, message: 'msg', plugin: 'test');
    }

    test('maps invalid-credential to InvalidCredentialsFailure', () {
      expect(
        FirebaseErrorMapper.map(firebaseException('invalid-credential')),
        isA<InvalidCredentialsFailure>(),
      );
    });

    test('maps wrong-password to InvalidCredentialsFailure', () {
      expect(
        FirebaseErrorMapper.map(firebaseException('wrong-password')),
        isA<InvalidCredentialsFailure>(),
      );
    });

    test('maps invalid-email to InvalidCredentialsFailure', () {
      expect(
        FirebaseErrorMapper.map(firebaseException('invalid-email')),
        isA<InvalidCredentialsFailure>(),
      );
    });

    test('maps email-already-in-use to EmailAlreadyExistsFailure', () {
      expect(
        FirebaseErrorMapper.map(firebaseException('email-already-in-use')),
        isA<EmailAlreadyExistsFailure>(),
      );
    });

    test('maps user-not-found to UserNotFoundFailure', () {
      expect(
        FirebaseErrorMapper.map(firebaseException('user-not-found')),
        isA<UserNotFoundFailure>(),
      );
    });

    test('maps too-many-requests to TooManyRequestsFailure', () {
      expect(
        FirebaseErrorMapper.map(firebaseException('too-many-requests')),
        isA<TooManyRequestsFailure>(),
      );
    });

    test('maps network-request-failed to NetworkFailure', () {
      expect(
        FirebaseErrorMapper.map(firebaseException('network-request-failed')),
        isA<NetworkFailure>(),
      );
    });

    test('maps canceled to CancelledFailure', () {
      expect(
        FirebaseErrorMapper.map(firebaseException('canceled')),
        isA<CancelledFailure>(),
      );
    });

    test('maps TimeoutException to TimeoutFailure', () {
      expect(
        FirebaseErrorMapper.map(TimeoutException('timed out')),
        isA<TimeoutFailure>(),
      );
    });

    test('maps SocketException to NetworkFailure', () {
      expect(
        FirebaseErrorMapper.map(const SocketException('no network')),
        isA<NetworkFailure>(),
      );
    });

    test('maps unknown Firebase code to UnknownFailure', () {
      expect(
        FirebaseErrorMapper.map(firebaseException('some-other-code')),
        isA<UnknownFailure>(),
      );
    });

    test('maps arbitrary exception to UnknownFailure', () {
      expect(
        FirebaseErrorMapper.map(StateError('boom')),
        isA<UnknownFailure>(),
      );
    });
  });
}
