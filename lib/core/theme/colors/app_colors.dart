import 'package:flutter/material.dart';

class AppColors {
  const AppColors();

  Color get primary => const Color(0xFFFE8C00);

  Color get backgroundPrimary => const Color(0xFFFFFFFF);
  Color get backgroundSecondary => const Color(0xFFF9F9F9);

  Color get textPrimary => const Color(0xFF292A2E);
  Color get textSecondary => const Color(0xFF878787);
  Color get textOnPrimary => const Color(0xFFFFFFFF);
  Color get textOnPrimaryAlt => const Color(0xFF101010);

  Color get iconPrimary => const Color(0xFFFE8C00);
  Color get iconText => const Color(0xFF292A2E);
  Color get iconSuccess => const Color(0xFF4CAF50);
  Color get iconError => const Color(0xFFF44336);
  Color get iconBlack => const Color(0xFF000000);
  Color get iconSecondary => const Color(0xFF878787);

  Color get white => backgroundPrimary;
  Color get success => iconSuccess;
  Color get error => iconError;
  Color get teal => const Color(0xFF008080);
  Color get blue => const Color(0xFF2196F3);
  Color get appBarBackground => backgroundPrimary;
  Color get bottomSheetBackground => backgroundSecondary;
  Color get disabledButtonBackground => const Color(0xFFBDBDBD);
  Color get secondaryScaffoldBackgroundColor => backgroundSecondary;
  Color get scaffoldBackgroundColor => backgroundPrimary;
}
