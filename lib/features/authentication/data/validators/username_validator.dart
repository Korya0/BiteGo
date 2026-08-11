import 'package:bite_go/core/constants/app_strings.dart';

class UsernameValidator {
  const UsernameValidator._();

  static final _startLetterRegExp = RegExp(r'^[a-zA-Z]');
  static final _allowedCharsRegExp = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$');

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.usernameEmptyError;
    }
    if (value.length < 3) {
      return AppStrings.usernameTooShortError;
    }
    if (value.length > 20) {
      return AppStrings.usernameTooLongError;
    }
    if (!_startLetterRegExp.hasMatch(value)) {
      return AppStrings.usernameStartLetterError;
    }
    if (!_allowedCharsRegExp.hasMatch(value)) {
      return AppStrings.usernameAllowedCharsError;
    }
    return null;
  }
}
