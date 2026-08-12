import 'package:bite_go/core/common/bottom_nav_bar/app_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainView extends StatelessWidget {
  const MainView({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
