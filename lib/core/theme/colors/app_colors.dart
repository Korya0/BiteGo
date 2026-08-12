import 'package:flutter/material.dart';

class AppColors {
  const AppColors();

  Color get primary => const Color(0xFFFE8C00);

  Color get backgroundPrimary => const Color(0xFFFFFFFF);
  Color get backgroundSecondary => const Color(0xFFF9F9F9);

  Color get textPrimary => const Color(0xFF292A2E);
  Color get textSecondary => const Color(0xFF878787);
  Color get textOnPrimary => const Color(0xFFFFFFFF);
  Color get textPrimaryStrong => const Color(0xFF111111);
  Color get textTertiary => const Color(0xFF999999);
  Color get textMuted => const Color(0xFF666666);

  Color get iconSecondary => const Color(0xFF878787);
  Color get iconSuccess => const Color(0xFF4CAF50);
  Color get iconError => const Color(0xFFF44336);
  Color get iconBlack => const Color(0xFF000000);

  Color get error => iconError;

  Color get link => const Color(0xFF2196F3);
  Color get disabledButtonBackground => const Color(0xFFBDBDBD);
  Color get starYellow => const Color(0xFFFFC107);
  Color get shimmerBase => const Color(0xFFE8E8E8);
  Color get shimmerHighlight => const Color(0xFFF5F5F5);
}
