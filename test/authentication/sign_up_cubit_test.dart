import 'dart:async';

import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/presentation/cubit/sign_up_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/sign_up_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

void main() {
  const validEmail = 'user@example.com';
  const validPassword = 'Password1';
  const validUsername = 'user1';

  late FakeAuthRepository repository;
  late SignUpCubit cubit;

  setUp(() {
    repository = FakeAuthRepository();
    cubit = SignUpCubit(authRepository: repository);
  });

  tearDown(() {
    cubit.close();
  });

  group('SignUpCubit', () {
    test('initial state is SignUpInitial', () {
      expect(cubit.state, isA<SignUpInitial>());
    });

    test('emits SignUpLoading then SignUpSuccess on success', () async {
      repository.signUpResult = Success<UserModel>(tUser);

      final states = <SignUpState>[];
      cubit.stream.listen(states.add);
      await cubit.signUp(
        email: validEmail,
        password: validPassword,
        username: validUsername,
      );
      await pumpEventQueue();

      expect(states, hasLength(2));
      expect(states[0], isA<SignUpLoading>());
      expect(states[1], isA<SignUpSuccess>());
      expect(repository.lastSignUpEmail, validEmail);
      expect(repository.lastSignUpPassword, validPassword);
      expect(repository.lastSignUpUsername, validUsername);
    });

    test('emits SignUpFailure for expected failures', () async {
      repository.signUpResult = const Error<UserModel>(EmailAlreadyExistsFailure());

      await cubit.signUp(
        email: validEmail,
        password: validPassword,
        username: validUsername,
      );

      expect(cubit.state, isA<SignUpFailure>());
      expect(
        (cubit.state as SignUpFailure).failure,
        isA<EmailAlreadyExistsFailure>(),
      );
    });

    test('rejects invalid email before calling the repository', () async {
      await cubit.signUp(
        email: 'invalid',
        password: validPassword,
        username: validUsername,
      );

      expect(cubit.state, isA<SignUpFailure>());
      expect((cubit.state as SignUpFailure).failure, isA<ValidationFailure>());
      expect(repository.signUpCalls, 0);
    });

    test('rejects invalid password before calling the repository', () async {
      await cubit.signUp(
        email: validEmail,
        password: 'short',
        username: validUsername,
      );

      expect(cubit.state, isA<SignUpFailure>());
      expect((cubit.state as SignUpFailure).failure, isA<ValidationFailure>());
      expect(repository.signUpCalls, 0);
    });

    test('rejects invalid username before calling the repository', () async {
      await cubit.signUp(
        email: validEmail,
        password: validPassword,
        username: '1abc',
      );

      expect(cubit.state, isA<SignUpFailure>());
      expect((cubit.state as SignUpFailure).failure, isA<ValidationFailure>());
      expect(repository.signUpCalls, 0);
    });

    test('does not submit again while loading', () async {
      repository.signUpResult = Success<UserModel>(tUser);
      repository.signUpGate = Completer<void>();

      final first = cubit.signUp(
        email: validEmail,
        password: validPassword,
        username: validUsername,
      );
      final second = cubit.signUp(
        email: validEmail,
        password: validPassword,
        username: validUsername,
      );
      expect(repository.signUpCalls, 1);

      repository.signUpGate!.complete();
      await first;
      await second;

      expect(repository.signUpCalls, 1);
      expect(cubit.state, isA<SignUpSuccess>());
    });

    test('signInWithGoogle emits SignUpSuccess on success', () async {
      repository.googleSignInResult = Success<UserModel>(tUser);

      await cubit.signInWithGoogle();

      expect(repository.googleSignInCalls, 1);
      expect(cubit.state, isA<SignUpSuccess>());
    });

    test('signInWithGoogle emits CancelledFailure on cancellation', () async {
      repository.googleSignInResult = const Error<UserModel>(CancelledFailure());

      await cubit.signInWithGoogle();

      expect(cubit.state, isA<SignUpFailure>());
      expect((cubit.state as SignUpFailure).failure, isA<CancelledFailure>());
    });
  });
}
