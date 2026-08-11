import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/di/app_injector.dart';
import 'package:bite_go/core/routes/app_router.dart';
import 'package:bite_go/core/theme/app_theme.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BiteGoApp extends StatelessWidget {
  const BiteGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthSessionCubit>(),
      child: MaterialApp.router(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: appRouter,
        builder: (context, child) {
          return GestureDetector(
            onTap: context.unfocus,
            child: child!,
          );
        },
      ),
    );
  }
}
