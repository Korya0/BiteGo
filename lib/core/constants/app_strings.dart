class AppStrings {
  const AppStrings._();

  static const appTitle = 'Bite Go';

  static const ok = 'OK';
  static const or = 'OR';

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

  // Pre-authentication screen.
  static const preAuthSlide1Title = 'Order Anything, Anytime';
  static const preAuthSlide1Subtitle =
      'Browse hundreds of restaurants and cuisines right at your fingertips';
  static const preAuthSlide2Title = 'Fast & Fresh Delivery';
  static const preAuthSlide2Subtitle =
      'Get your favourite meals delivered hot and fresh to your door';
  static const preAuthSlide3Title = 'Track Your Order Live';
  static const preAuthSlide3Subtitle =
      'Follow every step of your delivery in real time on the map';
  static const preAuthSignUpWithGoogle = 'Sign up with Google';
  static const preAuthSignUpWithEmail = 'Sign up with Email';
  static const preAuthAlreadyHaveAccount = 'Already have an account?';
  static const preAuthLogIn = 'Log in';

  // Login screen.
  static const loginTitle = 'Welcome Back!';
  static const loginSubtitle = 'Sign in to your account to continue.';
  static const loginAppBarTitle = 'Login';
  static const loginEmailLabel = 'Email';
  static const loginEmailHint = 'Enter your email';
  static const loginPasswordLabel = 'Password';
  static const loginPasswordHint = 'Enter your password';
  static const loginForgotPassword = 'Forgot password?';
  static const loginButton = 'Login';
  static const loginNoAccount = "Don't have an account?";
  static const loginSignUp = 'Sign Up';

  // Sign Up screen.
  static const signUpTitle = 'Create Account';
  static const signUpSubtitle = 'Fill in your details to get started.';
  static const signUpAppBarTitle = 'Sign Up';
  static const signUpEmailLabel = 'Email';
  static const signUpEmailHint = 'Enter your email';
  static const signUpPasswordLabel = 'Password';
  static const signUpPasswordHint = 'Create a password';
  static const signUpUsernameLabel = 'Username';
  static const signUpUsernameHint = 'Choose a username';
  static const signUpTermsPrefix = "By creating an account, you agree to BiteGo's ";
  static const signUpTermsLink = 'terms & conditions';
  static const signUpTermsAnd = ' and ';
  static const signUpPrivacyLink = 'privacy policy';
  static const signUpTermsSuffix = '.';
  static const signUpButton = 'Sign Up';
  static const signUpAlreadyHaveAccount = 'Already have an account?';
  static const signUpLogIn = 'Log In';

  // Forgot Password screen.
  static const forgotPasswordTitle = 'Reset Password';
  static const forgotPasswordAppBarTitle = 'Forgot Password';
  static const forgotPasswordEmailLabel = 'Email';
  static const forgotPasswordEmailHint = 'Enter your email';
  static const forgotPasswordHelperText =
      "Enter your registered email and we'll send you instructions to reset your password.";
  static const forgotPasswordButton = 'Send Instructions';

  // Home.
  static const homeTitle = 'Home';
  static const homeSectionPopularFoods = 'Popular Foods';
  static const homeGreeting = 'Good day! 👋';
  static const homeEmptyFoods = 'No food items found';
  static const homeRetry = 'Try Again';
  static const logoutTitle = 'Log Out';
  static const logoutMessage = 'Are you sure you want to log out?';
  static const logoutConfirm = 'Log Out';
  static const logoutCancel = 'Cancel';

  // Food Details.
  static const foodDetailsQuantity = 'Quantity';
  static const foodDetailsAddToCart = 'Add to Cart';

  // Forgot password feedback.
  static const forgotPasswordEmailSent =
      'Password reset email sent. Check your inbox and follow the link to set a new password.';

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
