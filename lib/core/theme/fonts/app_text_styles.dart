import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../fonts/font_family.dart';

class AppTextStyles {
  const AppTextStyles();

  TextStyle get title => GoogleFonts.inter(
    fontWeight: AppFontWeight.semiBold.value,
  );

  TextStyle get subtitle => GoogleFonts.inter(
    fontWeight: AppFontWeight.medium.value,
  );

  TextStyle get body => GoogleFonts.inter(
    fontWeight: AppFontWeight.regular.value,
  );

  TextStyle get caption => GoogleFonts.inter(
    fontWeight: AppFontWeight.regular.value,
  );
}
