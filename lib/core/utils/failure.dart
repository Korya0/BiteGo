abstract class Failure {
  final String message;

  const Failure(this.message);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([
    super.message = 'Invalid email or password. Please try again.',
  ]);
}

class EmailAlreadyExistsFailure extends Failure {
  const EmailAlreadyExistsFailure([
    super.message = 'This email is already registered. Please use a different one.',
  ]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection. Please check your network settings.',
  ]);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([
    super.message = 'The operation timed out. Please try again.',
  ]);
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure([
    super.message = 'User not found. Please check your credentials.',
  ]);
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure([
    super.message = 'Too many requests. Please try again later.',
  ]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'An unexpected error occurred. Please try again.',
  ]);
}
