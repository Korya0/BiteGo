import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/core/constants/app_assets.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Image.asset(
              AppAssets.imagesBiteGoLogoName,
            ).animate().fadeIn(
              duration: 1500.ms,
              curve: Curves.easeInOut,
            ),
      ),
    );
  }
}
