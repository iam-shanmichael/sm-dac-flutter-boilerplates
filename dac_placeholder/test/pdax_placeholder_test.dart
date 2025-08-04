import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dac_placeholder/dac_placeholder.dart';

void main() {
  testWidgets('Ensure "Title" and "Description" has set value', (WidgetTester tester) async {
    Widget testWidget() {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: DACPlaceHolder(
            title: DACConstants.defaultTitle,
            description: DACConstants.defaultDescription,
            hasButton: false,
          ),
        ),
      );
    }

    await tester.pumpWidget(testWidget());

    expect(find.text(DACConstants.defaultTitle), findsOneWidget);

    expect(find.text(DACConstants.defaultDescription), findsOneWidget);
  });

  testWidgets('Ensure button is visible', (WidgetTester tester) async {
    Widget testWidget() {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: DACPlaceHolder(
            title: DACConstants.defaultTitle,
            description: DACConstants.defaultDescription,
            hasButton: true,
          ),
        ),
      );
    }

    await tester.pumpWidget(testWidget());

    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Ensure button is hidden', (WidgetTester tester) async {
    Widget testWidget() {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: DACPlaceHolder(
            title: DACConstants.defaultTitle,
            description: DACConstants.defaultDescription,
            hasButton: false,
          ),
        ),
      );
    }

    await tester.pumpWidget(testWidget());

    expect(find.byType(ElevatedButton), findsNothing);
  });
}
