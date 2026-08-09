import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:bite_go/core/utils/context_extension.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;

  const AppAppBar({
    required this.title,
    super.key,
    this.actions,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.color.backgroundPrimary,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: context.color.backgroundPrimary,
        statusBarIconBrightness: context.isDarkMode
            ? Brightness.light
            : Brightness.dark,
      ),
      elevation: 0.005,
      scrolledUnderElevation: 0.005,
      shadowColor: context.color.iconBlack.withValues(alpha: context.opacity.medium),
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      leading: context.canPop()
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: context.color.textPrimary,
              ),
              onPressed: () {
                if (onBackPressed != null) {
                  onBackPressed!();
                } else {
                  context.pop();
                }
              },
            )
          : null,
      title: Text(
        title,
        style: context.textStyle.subtitle.copyWith(
          color: context.color.textPrimary,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
