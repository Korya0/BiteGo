import 'package:bite_go/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AppAssets.imagesBiteGoLogoName,
        ).animate().fadeIn(
          duration: 1500.ms,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
}
