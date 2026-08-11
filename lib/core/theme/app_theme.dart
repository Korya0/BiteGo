import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import './fonts/app_fonts.dart';
import './colors/app_colors.dart';

class AppTheme {
  AppTheme._();

  /// App-wide system bar style for edge-to-edge (light surfaces → dark icons).
  static const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    splashFactory: NoSplash.splashFactory,
    fontFamily: AppFonts.inter,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const AppColors().primary,
      surface: const AppColors().backgroundSecondary,
      onPrimary: const AppColors().textOnPrimary,
      onSurface: const AppColors().textPrimary,
      primary: const AppColors().primary,
    ),
    scaffoldBackgroundColor: const AppColors().backgroundPrimary,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: systemUiOverlayStyle,
    ),
    textTheme: GoogleFonts.interTextTheme().apply(
      fontFamily: AppFonts.inter,
    ),
  );
}
