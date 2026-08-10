import 'dart:async';

import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_text_button.dart';
import 'package:bite_go/core/constants/app_assets.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PreAuthenticationView extends StatelessWidget {
  const PreAuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: context.space.md,
          right: context.space.md,
          bottom: context.space.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(child: _CarouselSection()),

            AppGap.h(context.space.xxl + context.space.lg),

            // Footer Buttons
            _FooterButtons(
              onGooglePressed: () {},
              onEmailPressed: () => context.push(AppRoutes.authSignUp),
              onLoginPressed: () => context.push(AppRoutes.authLogin),
            ),
          ],
        ),
      ),
    );
  }
}

// Footer Buttons

class _FooterButtons extends StatelessWidget {
  const _FooterButtons({
    required this.onGooglePressed,
    required this.onEmailPressed,
    required this.onLoginPressed,
  });

  final VoidCallback onGooglePressed;
  final VoidCallback onEmailPressed;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.space.sm,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton.primary(
              text: AppStrings.preAuthSignUpWithGoogle,
              onPressed: onGooglePressed,
              leading: SvgPicture.asset(
                AppAssets.svgsGoogle,
                height: context.space.iconSm,
                width: context.space.iconSm,
                colorFilter: ColorFilter.mode(
                  context.color.textOnPrimary,
                  BlendMode.srcIn,
                ),
              ),
            )
            .animate()
            .fadeIn(delay: 0.ms, duration: 315.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.35,
              end: 0,
              delay: 0.ms,
              duration: 315.ms,
              curve: Curves.easeOutCubic,
            ),

        AppButton.primary(
              text: AppStrings.preAuthSignUpWithEmail,
              onPressed: onEmailPressed,
              leading: Icon(
                Icons.email_outlined,
                size: context.space.iconSm,
                color: context.color.textOnPrimary,
              ),
            )
            .animate()
            .fadeIn(delay: 105.ms, duration: 315.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.35,
              end: 0,
              delay: 105.ms,
              duration: 315.ms,
              curve: Curves.easeOutCubic,
            ),

        Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.preAuthAlreadyHaveAccount,
                  style: context.textStyle.body.copyWith(
                    fontSize: context.space.fontSizeSm,
                    color: context.color.textPrimary,
                  ),
                ),
                AppTextButton(
                  text: AppStrings.preAuthLogIn,
                  onPressed: onLoginPressed,
                  textStyle: context.textStyle.subtitle.copyWith(
                    fontSize: context.space.fontSizeSm,
                    color: context.color.primary,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.space.xs,
                    vertical: context.space.xs,
                  ),
                ),
              ],
            )
            .animate()
            .fadeIn(delay: 210.ms, duration: 315.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.35,
              end: 0,
              delay: 210.ms,
              duration: 315.ms,
              curve: Curves.easeOutCubic,
            ),
      ],
    );
  }
}

// Carousel Section

class _CarouselSection extends StatefulWidget {
  const _CarouselSection();

  @override
  State<_CarouselSection> createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<_CarouselSection> {
  int _currentIndex = 0;
  late final Timer _autoPlayTimer;

  static const List<_SlideData> _slides = [
    _SlideData(
      imagePath: AppAssets.svgsPreAuth1,
      title: AppStrings.preAuthSlide1Title,
      subtitle: AppStrings.preAuthSlide1Subtitle,
      indicatorPath: AppAssets.svgsIndicatorsBurger1,
    ),
    _SlideData(
      imagePath: AppAssets.svgsPreAuth2,
      title: AppStrings.preAuthSlide2Title,
      subtitle: AppStrings.preAuthSlide2Subtitle,
      indicatorPath: AppAssets.svgsIndicatorsBurger2,
    ),
    _SlideData(
      imagePath: AppAssets.svgsPreAuth3,
      title: AppStrings.preAuthSlide3Title,
      subtitle: AppStrings.preAuthSlide3Subtitle,
      indicatorPath: AppAssets.svgsIndicatorsBurger3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _slides.length;
      });
    });
  }

  @override
  void dispose() {
    _autoPlayTimer.cancel();
    super.dispose();
  }

  void _goToPage(int index) {
    _autoPlayTimer.cancel();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentIndex];

    return Column(
      children: [
        // Illustration: fade in/out
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: SvgPicture.asset(slide.imagePath, fit: BoxFit.contain),
          ),
        ),
        AppGap.h(context.space.xs),
        // Text: fade in/out
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 380),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: Column(
            key: ValueKey('text_$_currentIndex'),
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                slide.title,
                textAlign: TextAlign.center,
                style: context.textStyle.title.copyWith(
                  fontSize: context.space.fontSizeTitleSm,
                  color: context.color.textPrimary,
                ),
              ),
              AppGap.h(context.space.xs),

              Text(
                slide.subtitle,
                textAlign: TextAlign.center,
                style: context.textStyle.body.copyWith(
                  fontSize: context.space.fontSizeSm,
                  color: context.color.textSecondary,
                ),
              ),
            ],
          ),
        ),

        // Indicators: slide from top + fade animation
        SizedBox(
          height: context.space.iconSm * _slides.length,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(_currentIndex + 1, (index) {
              final reversedIndex = _currentIndex - index;
              return GestureDetector(
                key: ValueKey(reversedIndex),
                behavior: HitTestBehavior.opaque,
                onTap: () => _goToPage(reversedIndex),
                child: SvgPicture.asset(
                  _slides[reversedIndex].indicatorPath,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

// Slide Data Model

class _SlideData {
  const _SlideData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.indicatorPath,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final String indicatorPath;
}
