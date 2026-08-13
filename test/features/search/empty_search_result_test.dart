import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/features/search/presentation/widgets/empty_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EmptySearchResult renders the SVG and the exact message', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: EmptySearchResult())),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EmptySearchResult), findsOneWidget);
    expect(find.text(AppStrings.searchEmptyResult), findsOneWidget);
  });
}