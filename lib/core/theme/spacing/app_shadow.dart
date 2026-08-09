import 'package:flutter/material.dart';

class AppShadow {
  const AppShadow();

  List<BoxShadow> get sm => [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  List<BoxShadow> get md => [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  List<BoxShadow> get lg => [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.15),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}
