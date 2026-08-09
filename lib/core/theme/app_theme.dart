import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './fonts/app_fonts.dart';
import './colors/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: AppFonts.inter,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const AppColors().primary,
      surface: const AppColors().backgroundSecondary,
      onPrimary: const AppColors().textOnPrimary,
      onSurface: const AppColors().textPrimary,
      primary: const AppColors().primary,
    ),
    scaffoldBackgroundColor: const AppColors().backgroundPrimary,
    textTheme: GoogleFonts.interTextTheme().apply(
      fontFamily: AppFonts.inter,
    ),
  );
}
