import 'package:flutter/widgets.dart';

/// Supported font weights for the Inter font in BiteGo
enum AppFontWeight {
  medium(FontWeight.w500),
  semiBold(FontWeight.w600);

  const AppFontWeight(this.value);
  final FontWeight value;
}

abstract final class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Inter';

  // Base style configuration
  static final TextStyle _base = TextStyle(
    fontFamily: fontFamily,
    fontWeight: AppFontWeight.medium.value,
  );

  // Display Styles
  static final TextStyle displayLarge = _base.copyWith(
    fontSize: 57,
    fontWeight: AppFontWeight.semiBold.value,
    height: 1.12,
  );
  static final TextStyle displayMedium = _base.copyWith(
    fontSize: 45,
    fontWeight: AppFontWeight.semiBold.value,
    height: 1.16,
  );
  static final TextStyle displaySmall = _base.copyWith(
    fontSize: 36,
    fontWeight: AppFontWeight.semiBold.value,
    height: 1.22,
  );

  // Headline Styles
  static final TextStyle headlineLarge = _base.copyWith(
    fontSize: 32,
    fontWeight: AppFontWeight.semiBold.value,
    height: 1.25,
  );
  static final TextStyle headlineMedium = _base.copyWith(
    fontSize: 28,
    fontWeight: AppFontWeight.semiBold.value,
    height: 1.29,
  );
  static final TextStyle headlineSmall = _base.copyWith(
    fontSize: 24,
    fontWeight: AppFontWeight.semiBold.value,
    height: 1.33,
  );

  // Title Styles
  static final TextStyle titleLarge = _base.copyWith(
    fontSize: 22,
    fontWeight: AppFontWeight.semiBold.value,
    height: 1.27,
  );
  static final TextStyle titleMedium = _base.copyWith(
    fontSize: 16,
    fontWeight: AppFontWeight.medium.value,
    height: 1.5,
    letterSpacing: 0.15,
  );
  static final TextStyle titleSmall = _base.copyWith(
    fontSize: 14,
    fontWeight: AppFontWeight.medium.value,
    height: 1.43,
    letterSpacing: 0.1,
  );

  // Body Styles
  static final TextStyle bodyLarge = _base.copyWith(
    fontSize: 16,
    fontWeight: AppFontWeight.medium.value,
    height: 1.5,
    letterSpacing: 0.5,
  );
  static final TextStyle bodyMedium = _base.copyWith(
    fontSize: 14,
    fontWeight: AppFontWeight.medium.value,
    height: 1.43,
    letterSpacing: 0.25,
  );
  static final TextStyle bodySmall = _base.copyWith(
    fontSize: 12,
    fontWeight: AppFontWeight.medium.value,
    height: 1.33,
    letterSpacing: 0.4,
  );

  // Label Styles
  static final TextStyle labelLarge = _base.copyWith(
    fontSize: 14,
    fontWeight: AppFontWeight.semiBold.value,
    height: 1.43,
    letterSpacing: 0.1,
  );
  static final TextStyle labelMedium = _base.copyWith(
    fontSize: 12,
    fontWeight: AppFontWeight.medium.value,
    height: 1.33,
    letterSpacing: 0.5,
  );
  static final TextStyle labelSmall = _base.copyWith(
    fontSize: 11,
    fontWeight: AppFontWeight.medium.value,
    height: 1.45,
    letterSpacing: 0.5,
  );
}
