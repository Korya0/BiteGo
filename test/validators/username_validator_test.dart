import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/features/authentication/data/validators/username_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UsernameValidator.validate', () {
    test('returns empty error for null', () {
      expect(UsernameValidator.validate(null), AppStrings.usernameEmptyError);
    });

    test('returns empty error for empty string', () {
      expect(UsernameValidator.validate(''), AppStrings.usernameEmptyError);
    });

    test('returns too short error below 3 characters', () {
      expect(
        UsernameValidator.validate('ab'),
        AppStrings.usernameTooShortError,
      );
    });

    test('returns too long error above 20 characters', () {
      expect(
        UsernameValidator.validate('a' * 21),
        AppStrings.usernameTooLongError,
      );
    });

    test('returns start letter error when starting with a non-letter', () {
      expect(
        UsernameValidator.validate('1abc'),
        AppStrings.usernameStartLetterError,
      );
    });

    test('returns allowed characters error for invalid characters', () {
      expect(
        UsernameValidator.validate('abc!'),
        AppStrings.usernameAllowedCharsError,
      );
      expect(
        UsernameValidator.validate('abc-123'),
        AppStrings.usernameAllowedCharsError,
      );
    });

    test('returns null for a valid username', () {
      expect(UsernameValidator.validate('abc'), isNull);
      expect(UsernameValidator.validate('user_name_123'), isNull);
      expect(UsernameValidator.validate('UsErName'), isNull);
    });
  });
}
