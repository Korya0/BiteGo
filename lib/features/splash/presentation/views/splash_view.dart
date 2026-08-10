import 'package:bite_go/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key, required this.onCompleted});

  final VoidCallback onCompleted;

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 1500),
      () {
        if (mounted) widget.onCompleted();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AppAssets.imagesBiteGoLogoName).animate().fadeIn(
          duration: 1500.ms,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
}
