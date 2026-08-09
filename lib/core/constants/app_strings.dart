class AppStrings {
  const AppStrings._();

  static const appTitle = 'Bite Go';

  static const ok = 'OK';

  // Email validation.
  static const emailEmptyError = 'Email cannot be empty.';
  static const emailInvalidError = 'Please enter a valid email address.';

  // Password validation.
  static const passwordEmptyError = 'Password cannot be empty.';
  static const passwordTooShortError =
      'Password must be at least 8 characters long.';
  static const passwordTooLongError =
      'Password must be at most 64 characters long.';
  static const passwordMissingUppercaseError =
      'Password must contain at least one uppercase letter.';
  static const passwordMissingLowercaseError =
      'Password must contain at least one lowercase letter.';
  static const passwordMissingNumberError =
      'Password must contain at least one number.';
  static const passwordArabicNotAllowedError =
      'Password must contain only Latin letters, numbers, and symbols.';

  // Username validation.
  static const usernameEmptyError = 'Username cannot be empty.';
  static const usernameTooShortError =
      'Username must be at least 3 characters long.';
  static const usernameTooLongError =
      'Username must be at most 20 characters long.';
  static const usernameStartLetterError = 'Username must start with a letter.';
  static const usernameAllowedCharsError =
      'Username can only contain letters, numbers, and underscores.';

  // Failure messages.
  static const invalidInputError = 'Please enter valid information.';
  static const invalidCredentialsError =
      'Invalid email or password. Please try again.';
  static const emailAlreadyInUseError =
      'This email is already registered. Please use a different one.';
  static const networkError =
      'No internet connection. Please check your network settings.';
  static const timeoutError = 'The operation timed out. Please try again.';
  static const userNotFoundError =
      'User not found. Please check your credentials.';
  static const tooManyRequestsError =
      'Too many requests. Please try again later.';
  static const cancelledError = 'Sign-in was cancelled.';
  static const unknownError = 'An unexpected error occurred. Please try again.';
}
