import 'package:flutter/foundation.dart';

import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';

@immutable
sealed class SignUpState {
  const SignUpState();
}

final class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

final class SignUpLoading extends SignUpState {
  const SignUpLoading();
}

final class SignUpSuccess extends SignUpState {
  const SignUpSuccess(this.user);

  final UserModel user;
}

final class SignUpFailure extends SignUpState {
  const SignUpFailure(this.failure);

  final Failure failure;
}
