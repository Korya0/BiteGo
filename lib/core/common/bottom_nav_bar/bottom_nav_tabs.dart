import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

class BottomNavTabConfig {
  const BottomNavTabConfig({
    required this.label,
    required this.icon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final String path;
}

const List<BottomNavTabConfig> bottomNavTabs = [
  BottomNavTabConfig(
    label: AppStrings.bottomNavHome,
    icon: Icons.home_rounded,
    path: AppRoutes.home,
  ),
  BottomNavTabConfig(
    label: AppStrings.bottomNavCart,
    icon: Icons.shopping_cart_rounded,
    path: AppRoutes.cart,
  ),
  BottomNavTabConfig(
    label: AppStrings.bottomNavProfile,
    icon: Icons.person_rounded,
    path: AppRoutes.profile,
  ),
];
