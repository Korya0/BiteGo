import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/constants/app_assets.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AppButton.primary(
      text: AppStrings.preAuthSignUpWithGoogle,
      onPressed: onPressed,
      isLoading: isLoading,
      leading: SvgPicture.asset(
        AppAssets.svgsGoogle,
        height: context.space.iconSm,
        width: context.space.iconSm,
        colorFilter: ColorFilter.mode(
          context.color.textOnPrimary,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
