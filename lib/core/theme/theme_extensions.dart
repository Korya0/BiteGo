import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_sizes.dart';

extension ThemeExtensions on BuildContext {
  /// Access to design system colors
  ThemeColors get colors => ThemeColors.instance;

  /// Access to theme text styles (which are loaded from Material TextTheme)
  TextTheme get textStyles => Theme.of(this).textTheme;

  /// Access to design system sizes
  ThemeSizes get sizes => ThemeSizes.instance;
}

/// Helper class to namespace AppColors through context
class ThemeColors {
  const ThemeColors._();
  static const ThemeColors instance = ThemeColors._();

  Color get primary => AppColors.primary;
  Color get backgroundPrimary => AppColors.backgroundPrimary;
  Color get backgroundSecondary => AppColors.backgroundSecondary;

  Color get textPrimary => AppColors.textPrimary;
  Color get textSecondary => AppColors.textSecondary;
  Color get textOnPrimary => AppColors.textOnPrimary;
  Color get textOnPrimaryAlt => AppColors.textOnPrimaryAlt;

  Color get iconPrimary => AppColors.iconPrimary;
  Color get iconText => AppColors.iconText;
  Color get iconSuccess => AppColors.iconSuccess;
  Color get iconError => AppColors.iconError;
  Color get iconBlack => AppColors.iconBlack;
  Color get iconSecondary => AppColors.iconSecondary;

  Color get borderPrimary => AppColors.borderPrimary;
  Color get borderSecondary => AppColors.borderSecondary;

  Color get success => AppColors.success;
  Color get warning => AppColors.warning;
  Color get error => AppColors.error;
  Color get info => AppColors.info;
}

/// Helper class to namespace AppSizes through context
class ThemeSizes {
  const ThemeSizes._();
  static const ThemeSizes instance = ThemeSizes._();

  double get spacingXs => AppSizes.spacingXs;
  double get spacingSm => AppSizes.spacingSm;
  double get spacingMd => AppSizes.spacingMd;
  double get spacingLg => AppSizes.spacingLg;
  double get spacingXl => AppSizes.spacingXl;
  double get spacingXxl => AppSizes.spacingXxl;

  double get buttonHeight => AppSizes.buttonHeight;
  double get inputHeight => AppSizes.inputHeight;
  double get appBarHeight => AppSizes.appBarHeight;

  double get iconSm => AppSizes.iconSm;
  double get iconMd => AppSizes.iconMd;
  double get iconLg => AppSizes.iconLg;

  double get radiusSm => AppSizes.radiusSm;
  double get radiusMd => AppSizes.radiusMd;
  double get radiusLg => AppSizes.radiusLg;
  double get radiusFull => AppSizes.radiusFull;

  double get avatarSm => AppSizes.avatarSm;
  double get avatarMd => AppSizes.avatarMd;
  double get avatarLg => AppSizes.avatarLg;
}
