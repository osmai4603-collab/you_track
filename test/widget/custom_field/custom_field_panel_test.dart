import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:issues_tracking/features/custom_fields/presentation/pages/add_custom_field_page.dart';

void main() {
  group('AddCustomFieldPage', () {
    testWidgets('should show add field button', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AddCustomFieldPage(),
        ),
      ));

      // Expect to find a button with text 'Add field'
      expect(find.text('Add field'), findsOneWidget);
    });

    testWidgets('should open sliding panel when button tapped', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AddCustomFieldPage(),
        ),
      ));

      // Tap the add field button
      await tester.tap(find.text('Add field'));
      await tester.pumpAndSettle();

      // Expect to find the panel with sliding animation
      // This will fail until panel is implemented
      expect(find.byKey(Key('sliding_panel')), findsOneWidget);
    });
  });
}