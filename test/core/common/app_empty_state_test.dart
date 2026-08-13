import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_empty_state.dart';
import 'package:bite_go/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppEmptyState renders asset, message and optional action', (
    tester,
  ) async {
    var actionPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppEmptyState(
            assetPath: AppAssets.svgsCouldntFindResult,
            title: 'Ouch! Hungry',
            message: 'Seems like you have not ordered any food yet',
            actionLabel: 'Find Foods',
            onActionPressed: () => actionPressed = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.text('Ouch! Hungry'), findsOneWidget);
    expect(find.text('Seems like you have not ordered any food yet'), findsOneWidget);
    expect(find.byType(AppButton), findsOneWidget);

    await tester.tap(find.text('Find Foods'));
    await tester.pump();
    expect(actionPressed, isTrue);
  });

  testWidgets('AppEmptyState renders without title or action', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppEmptyState(
            assetPath: AppAssets.svgsCouldntFindResult,
            message: 'No results found',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No results found'), findsOneWidget);
    expect(find.byType(AppButton), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
