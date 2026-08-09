import 'package:flutter/foundation.dart';

import 'package:bite_go/core/utils/failure.dart';

@immutable
sealed class ForgotPasswordState {
  const ForgotPasswordState();
}

final class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

final class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading();
}

final class ForgotPasswordEmailSent extends ForgotPasswordState {
  const ForgotPasswordEmailSent();
}

final class ForgotPasswordFailure extends ForgotPasswordState {
  const ForgotPasswordFailure(this.failure);

  final Failure failure;
}
