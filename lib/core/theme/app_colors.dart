import 'package:flutter/widgets.dart';

abstract final class AppColors {
  AppColors._();

  // Brand colors
  static const Color primary = Color(0xFFFE8C00);

  // Background colors
  static const Color backgroundPrimary = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF9F9F9);

  // Text colors
  static const Color textPrimary = Color(0xFF292A2E);
  static const Color textSecondary = Color(0xFF878787);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnPrimaryAlt = Color(0xFF101010); // Alternative dark text on primary

  // Icon colors
  static const Color iconPrimary = Color(0xFFFE8C00);
  static const Color iconText = Color(0xFF292A2E);
  static const Color iconSuccess = Color(0xFF4CAF50);
  static const Color iconError = Color(0xFFF44336);
  static const Color iconBlack = Color(0xFF000000);
  static const Color iconSecondary = Color(0xFF878787);

  // Borders
  static const Color borderPrimary = Color(0xFFE2E8F0);
  static const Color borderSecondary = Color(0xFFCBD5E1);

  // State colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
}
