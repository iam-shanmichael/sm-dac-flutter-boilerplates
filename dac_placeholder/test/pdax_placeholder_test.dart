import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdax_placeholder/pdax_placeholder.dart';

void main() {
  testWidgets('Ensure "Title" and "Description" has set value', (WidgetTester tester) async {
    Widget testWidget() {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: PDAXPlaceHolder(
            title: PDAXConstants.defaultTitle,
            description: PDAXConstants.defaultDescription,
            hasButton: false,
          ),
        ),
      );
    }

    await tester.pumpWidget(testWidget());

    expect(find.text(PDAXConstants.defaultTitle), findsOneWidget);

    expect(find.text(PDAXConstants.defaultDescription), findsOneWidget);
  });

  testWidgets('Ensure button is visible', (WidgetTester tester) async {
    Widget testWidget() {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: PDAXPlaceHolder(
            title: PDAXConstants.defaultTitle,
            description: PDAXConstants.defaultDescription,
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
          body: PDAXPlaceHolder(
            title: PDAXConstants.defaultTitle,
            description: PDAXConstants.defaultDescription,
            hasButton: false,
          ),
        ),
      );
    }

    await tester.pumpWidget(testWidget());

    expect(find.byType(ElevatedButton), findsNothing);
  });
}
