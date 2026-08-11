import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/features/authentication/data/validators/password_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PasswordValidator.validate', () {
    test('returns empty error for null', () {
      expect(PasswordValidator.validate(null), AppStrings.passwordEmptyError);
    });

    test('returns empty error for empty string', () {
      expect(PasswordValidator.validate(''), AppStrings.passwordEmptyError);
    });

    test('rejects Arabic characters', () {
      expect(
        PasswordValidator.validate('مرور1Aa'),
        AppStrings.passwordArabicNotAllowedError,
      );
    });

    test('returns too short error below 8 characters', () {
      expect(
        PasswordValidator.validate('Ab1cD'),
        AppStrings.passwordTooShortError,
      );
    });

    test('returns too long error above 64 characters', () {
      final value = 'A${'a' * 65}1';
      expect(PasswordValidator.validate(value), AppStrings.passwordTooLongError);
    });

    test('returns missing uppercase error', () {
      expect(
        PasswordValidator.validate('password1'),
        AppStrings.passwordMissingUppercaseError,
      );
    });

    test('returns missing lowercase error', () {
      expect(
        PasswordValidator.validate('PASSWORD1'),
        AppStrings.passwordMissingLowercaseError,
      );
    });

    test('returns missing number error', () {
      expect(
        PasswordValidator.validate('Password'),
        AppStrings.passwordMissingNumberError,
      );
    });

    test('returns null for a valid password', () {
      expect(PasswordValidator.validate('Password1'), isNull);
      expect(PasswordValidator.validate('pAssword_2024!'), isNull);
    });
  });
}
