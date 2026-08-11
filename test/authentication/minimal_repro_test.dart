import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/features/authentication/presentation/cubit/login_cubit.dart';
import 'package:bite_go/features/authentication/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/fakes.dart';

void main() {
  testWidgets('minimal login pump', (tester) async {
    final repo = FakeAuthRepository();
    final cubit = LoginCubit(authRepository: repo);
    addTearDown(cubit.close);
    addTearDown(repo.authStateChangesController.close);
    final router = GoRouter(
      initialLocation: AppRoutes.authLogin,
      routes: [
        GoRoute(
          path: AppRoutes.authLogin,
          builder: (context, state) =>
              BlocProvider.value(value: cubit, child: const LoginView()),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text(AppStrings.loginTitle), findsOneWidget);
  });
}
