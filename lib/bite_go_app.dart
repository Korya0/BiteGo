import 'package:bite_go/core/constants/app_constants.dart';
import 'package:bite_go/core/theme/app_theme.dart';
import 'package:bite_go/core/routes/app_router.dart';
import 'package:flutter/material.dart';

class BiteGoApp extends StatelessWidget {
  const BiteGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appTitle,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
