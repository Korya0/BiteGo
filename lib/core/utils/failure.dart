import 'package:bite_go/core/constants/app_strings.dart';

abstract class Failure {
  final String message;

  const Failure(this.message);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([
    super.message = AppStrings.invalidCredentialsError,
  ]);
}

class EmailAlreadyExistsFailure extends Failure {
  const EmailAlreadyExistsFailure([
    super.message = AppStrings.emailAlreadyInUseError,
  ]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = AppStrings.networkError,
  ]);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([
    super.message = AppStrings.timeoutError,
  ]);
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure([
    super.message = AppStrings.userNotFoundError,
  ]);
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure([
    super.message = AppStrings.tooManyRequestsError,
  ]);
}

class CancelledFailure extends Failure {
  const CancelledFailure([
    super.message = AppStrings.cancelledError,
  ]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = AppStrings.unknownError,
  ]);
}
