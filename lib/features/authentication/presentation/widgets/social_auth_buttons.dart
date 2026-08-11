import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_text_divider.dart';
import 'package:bite_go/core/constants/app_assets.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({
    required this.onGooglePressed,
    required this.onFacebookPressed,
    super.key,
  });

  final VoidCallback onGooglePressed;
  final VoidCallback onFacebookPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppTextDivider(text: AppStrings.socialAuthOr),
        AppGap.h(context.space.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialButton(
              assetPath: AppAssets.svgsGoogle,
              label: AppStrings.socialAuthGoogle,
              onPressed: onGooglePressed,
            ),
            AppGap.w(context.space.lg),
            _SocialButton(
              assetPath: AppAssets.svgsFacebook,
              label: AppStrings.socialAuthFacebook,
              onPressed: onFacebookPressed,
            ),
          ],
        ),
      ],
    );
  }
}

// Social Button

class _SocialButton extends StatefulWidget {
  const _SocialButton({
    required this.assetPath,
    required this.label,
    required this.onPressed,
  });

  final String assetPath;
  final String label;
  final VoidCallback onPressed;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      button: true,
      child: Listener(
        onPointerDown: (_) => setState(() => _isPressed = true),
        onPointerUp: (_) => setState(() => _isPressed = false),
        onPointerCancel: (_) => setState(() => _isPressed = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          behavior: HitTestBehavior.opaque,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 50),
            opacity: _isPressed ? context.opacity.medium : 1.0,
            child: Container(
              width: context.space.xxl,
              height: context.space.xxl,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.color.backgroundPrimary,
                border: Border.all(
                  color: context.color.disabledButtonBackground,
                ),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                widget.assetPath,
                width: context.space.md + context.space.xs,
                height: context.space.md + context.space.xs,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
