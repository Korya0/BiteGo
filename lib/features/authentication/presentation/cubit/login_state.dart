import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  const LoginSuccess(this.user);

  final UserModel user;
}

final class LoginFailure extends LoginState {
  const LoginFailure(this.failure);

  final Failure failure;
}
