import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dac_textfield/dac_text_field.dart';

void main() {
  Widget testWidget() {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(
          child: DACTextField(
            initialValue: 'Hello',
            hintText: 'Hint',
            isCurrency: true,
          ),
        ),
      ),
    );
  }

  testWidgets('Ensure TextField has initial value', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());

    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('Ensure TextField has hint value', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());

    expect(find.text('Hint'), findsOneWidget);
  });

  testWidgets('Ensure TextField has prefix when isCurrency is true', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());

    expect(find.text('PHP'), findsOneWidget);
  });
}
