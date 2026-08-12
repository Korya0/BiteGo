import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

enum BottomNavTab { home, orders, cart, profile }

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.currentTab,
    required this.onTabSelected,
    super.key,
  });

  final BottomNavTab currentTab;
  final void Function(BottomNavTab tab) onTabSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.color.backgroundPrimary,
        boxShadow: context.shadow.md,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.space.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: currentTab == BottomNavTab.home,
                onTap: () => onTabSelected(BottomNavTab.home),
              ),
              _NavItem(
                icon: Icons.receipt_long_rounded,
                label: 'Orders',
                isActive: currentTab == BottomNavTab.orders,
                onTap: () => onTabSelected(BottomNavTab.orders),
              ),
              _NavItem(
                icon: Icons.shopping_cart_rounded,
                label: 'Cart',
                isActive: currentTab == BottomNavTab.cart,
                onTap: () => onTabSelected(BottomNavTab.cart),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isActive: currentTab == BottomNavTab.profile,
                onTap: () => onTabSelected(BottomNavTab.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? context.color.primary : context.color.iconSecondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: context.space.iconMd),
            const SizedBox(height: 2),
            Text(
              label,
              style: context.textStyle.caption.copyWith(
                fontSize: 10,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
