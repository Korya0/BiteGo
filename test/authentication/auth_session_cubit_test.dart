import 'dart:async';

import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

void main() {
  late FakeAuthRepository repository;
  late FakeErrorReporter reporter;
  late StreamController<Result<UserModel?>> controller;
  late AuthSessionCubit cubit;

  setUp(() {
    controller = StreamController<Result<UserModel?>>();
    repository = FakeAuthRepository(authStateChangesController: controller);
    reporter = FakeErrorReporter();
    cubit = AuthSessionCubit(
      authRepository: repository,
      errorReporter: reporter,
    );
  });

  tearDown(() async {
    if (!cubit.isClosed) {
      await cubit.close();
    }
    await controller.close();
  });

  Future<void> pumpEvent() => Future<void>.delayed(Duration.zero);

  group('AuthSessionCubit', () {
    test('initial state is AuthSessionUnknown', () {
      expect(cubit.state, isA<AuthSessionUnknown>());
    });

    test('emits Authenticated when a user is emitted', () async {
      controller.add(Success<UserModel?>(tUser));
      await pumpEvent();

      expect(cubit.state, isA<Authenticated>());
      expect((cubit.state as Authenticated).user.uid, tUser.uid);
      expect(reporter.userIdentifier, tUser.uid);
    });

    test('emits Unauthenticated when null is emitted', () async {
      controller.add(const Success<UserModel?>(null));
      await pumpEvent();

      expect(cubit.state, isA<Unauthenticated>());
      expect(reporter.userIdentifier, '');
    });

    test('ignores error events and keeps the current state', () async {
      controller.add(const Success<UserModel?>(null));
      await pumpEvent();
      expect(cubit.state, isA<Unauthenticated>());

      controller.add(const Error<UserModel?>(UnknownFailure()));
      await pumpEvent();

      expect(cubit.state, isA<Unauthenticated>());
    });

    test('clears user identifier on logout transition', () async {
      controller.add(Success<UserModel?>(tUser));
      await pumpEvent();
      expect(reporter.userIdentifier, tUser.uid);

      controller.add(const Success<UserModel?>(null));
      await pumpEvent();

      expect(cubit.state, isA<Unauthenticated>());
      expect(reporter.userIdentifier, '');
    });

    test('logout delegates to the repository', () async {
      repository.logoutResult = const Success<void>(null);

      final result = await cubit.logout();

      expect(repository.logoutCalls, 1);
      expect(result, isA<Success<void>>());
    });

    test('logout surfaces repository errors without emitting a state', () async {
      repository.logoutResult = const Error<void>(UnknownFailure());

      final result = await cubit.logout();

      expect(repository.logoutCalls, 1);
      expect(result, isA<Error<void>>());
      expect(cubit.state, isA<AuthSessionUnknown>());
    });

    test('cancels the subscription on close', () async {
      await cubit.close();
      expect(controller.hasListener, isFalse);
      await controller.close();
    });
  });
}
