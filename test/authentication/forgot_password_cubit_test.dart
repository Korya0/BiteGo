import 'dart:async';

import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/presentation/cubit/forgot_password_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/forgot_password_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

void main() {
  const validEmail = 'user@example.com';

  late FakeAuthRepository repository;
  late ForgotPasswordCubit cubit;

  setUp(() {
    repository = FakeAuthRepository();
    cubit = ForgotPasswordCubit(authRepository: repository);
  });

  tearDown(() {
    cubit.close();
  });

  group('ForgotPasswordCubit', () {
    test('initial state is ForgotPasswordInitial', () {
      expect(cubit.state, isA<ForgotPasswordInitial>());
    });

    test('emits Loading then EmailSent on success', () async {
      repository.resetPasswordResult = const Success<void>(null);

      final states = <ForgotPasswordState>[];
      cubit.stream.listen(states.add);
      await cubit.sendResetEmail(email: validEmail);
      await pumpEventQueue();

      expect(states, hasLength(2));
      expect(states[0], isA<ForgotPasswordLoading>());
      expect(states[1], isA<ForgotPasswordEmailSent>());
      expect(repository.lastResetEmail, validEmail);
    });

    test('emits Failure when the repository fails', () async {
      repository.resetPasswordResult = const Error<void>(UserNotFoundFailure());

      await cubit.sendResetEmail(email: validEmail);

      expect(cubit.state, isA<ForgotPasswordFailure>());
      expect(
        (cubit.state as ForgotPasswordFailure).failure,
        isA<UserNotFoundFailure>(),
      );
    });

    test('rejects invalid email before calling the repository', () async {
      await cubit.sendResetEmail(email: 'invalid');

      expect(cubit.state, isA<ForgotPasswordFailure>());
      expect(
        (cubit.state as ForgotPasswordFailure).failure,
        isA<ValidationFailure>(),
      );
      expect(repository.resetPasswordCalls, 0);
    });

    test('does not send again while loading', () async {
      repository.resetPasswordResult = const Success<void>(null);
      repository.resetPasswordGate = Completer<void>();

      final first = cubit.sendResetEmail(email: validEmail);
      final second = cubit.sendResetEmail(email: validEmail);
      expect(repository.resetPasswordCalls, 1);

      repository.resetPasswordGate!.complete();
      await first;
      await second;

      expect(repository.resetPasswordCalls, 1);
      expect(cubit.state, isA<ForgotPasswordEmailSent>());
    });
  });
}
