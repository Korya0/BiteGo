import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/bottom_nav_bar/bottom_nav_tabs.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.currentIndex,
    required this.onTabSelected,
    super.key,
  });

  final int currentIndex;
  final void Function(int index) onTabSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.space.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var index = 0; index < bottomNavTabs.length; index++)
              _NavItem(
                tab: bottomNavTabs[index],
                isActive: index == currentIndex,
                onTap: () => onTabSelected(index),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  final BottomNavTabConfig tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? context.color.primary
        : context.color.iconSecondary;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: context.space.xxl + context.space.md,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(tab.icon, color: color, size: context.iconSize.md),
              const AppGap.h(2),
              Text(
                tab.label,
                style: context.textStyle.caption.copyWith(
                  fontSize: 10,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
