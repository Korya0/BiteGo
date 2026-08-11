import 'dart:async';

import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/presentation/cubit/login_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/login_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

void main() {
  const validEmail = 'user@example.com';
  const validPassword = 'Password1';

  late FakeAuthRepository repository;
  late LoginCubit cubit;

  setUp(() {
    repository = FakeAuthRepository();
    cubit = LoginCubit(authRepository: repository);
  });

  tearDown(() {
    cubit.close();
  });

  group('LoginCubit', () {
    test('initial state is LoginInitial', () {
      expect(cubit.state, isA<LoginInitial>());
    });

    test('emits LoginLoading then LoginSuccess on success', () async {
      repository.loginResult = Success<UserModel>(tUser);

      final states = <LoginState>[];
      cubit.stream.listen(states.add);
      await cubit.login(email: validEmail, password: validPassword);
      await pumpEventQueue();

      expect(states, hasLength(2));
      expect(states[0], isA<LoginLoading>());
      expect(states[1], isA<LoginSuccess>());
      expect(cubit.state, isA<LoginSuccess>());
      expect((cubit.state as LoginSuccess).user.uid, tUser.uid);
      expect(repository.lastLoginEmail, validEmail);
      expect(repository.lastLoginPassword, validPassword);
    });

    test('emits LoginFailure for expected failures', () async {
      repository.loginResult = const Error<UserModel>(InvalidCredentialsFailure());

      await cubit.login(email: validEmail, password: validPassword);

      expect(cubit.state, isA<LoginFailure>());
      expect(
        (cubit.state as LoginFailure).failure,
        isA<InvalidCredentialsFailure>(),
      );
    });

    test('emits LoginFailure for unexpected failures', () async {
      repository.loginResult = const Error<UserModel>(UnknownFailure());

      await cubit.login(email: validEmail, password: validPassword);

      expect(cubit.state, isA<LoginFailure>());
      expect((cubit.state as LoginFailure).failure, isA<UnknownFailure>());
    });

    test('rejects invalid email before calling the repository', () async {
      await cubit.login(email: 'invalid', password: validPassword);

      expect(cubit.state, isA<LoginFailure>());
      expect((cubit.state as LoginFailure).failure, isA<ValidationFailure>());
      expect(repository.loginCalls, 0);
    });

    test('rejects invalid password before calling the repository', () async {
      await cubit.login(email: validEmail, password: 'short');

      expect(cubit.state, isA<LoginFailure>());
      expect((cubit.state as LoginFailure).failure, isA<ValidationFailure>());
      expect(repository.loginCalls, 0);
    });

    test('does not emit loading again for duplicate submissions', () async {
      repository.loginResult = Success<UserModel>(tUser);
      repository.loginGate = Completer<void>();

      final first = cubit.login(email: validEmail, password: validPassword);
      final second = cubit.login(email: validEmail, password: validPassword);
      expect(repository.loginCalls, 1);

      repository.loginGate!.complete();
      await first;
      await second;

      expect(repository.loginCalls, 1);
      expect(cubit.state, isA<LoginSuccess>());
    });

    test('signInWithGoogle emits LoginSuccess on success', () async {
      repository.googleSignInResult = Success<UserModel>(tUser);

      await cubit.signInWithGoogle();

      expect(repository.googleSignInCalls, 1);
      expect(cubit.state, isA<LoginSuccess>());
    });

    test('signInWithGoogle emits CancelledFailure on cancellation', () async {
      repository.googleSignInResult = const Error<UserModel>(CancelledFailure());

      await cubit.signInWithGoogle();

      expect(cubit.state, isA<LoginFailure>());
      expect((cubit.state as LoginFailure).failure, isA<CancelledFailure>());
    });
  });
}
