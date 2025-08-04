import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dac_dialog/src/dialogs/dac_dialog/dac_dialog.dart';

void main() {
  Widget testWidget({
    bool isDismissible = false,
    Widget? icon,
    String? title,
    String? description,
    String positiveActionText = 'Confirm',
    String? negativeActionText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) => ElevatedButton(
              child: const Text('Show Dialog Button'),
              onPressed: () {
                DACDialog(
                  context,
                  isDismissible: isDismissible,
                  icon: icon,
                  title: title,
                  description: description,
                  positiveActionText: positiveActionText,
                  onConfirm: onConfirm,
                  negativeActionText: negativeActionText,
                  onCancel: onCancel,
                ).show();
              },
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('Ensure that the dialog is showing', (WidgetTester tester) async {
    await tester.pumpWidget(
      testWidget(
        title: 'DAC Dialog',
        description: 'This is a description.',
      ),
    );
    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.byType(Dialog), findsOneWidget);

    // Find the title
    expect(find.textContaining('DAC Dialog'), findsOneWidget);

    // Find the description
    expect(find.textContaining('This is a description.'), findsOneWidget);

    // Only the positive action button is present.
    expect(find.byKey(const Key('positiveAction')), findsOneWidget);
    expect(find.byKey(const Key('negativeAction')), findsNothing);
  });

  testWidgets('Dialog dismissible test', (WidgetTester tester) async {
    await tester.pumpWidget(
      testWidget(
        isDismissible: true,
        title: 'DAC Dialog',
        description: 'This is a description.',
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.byType(Dialog), findsOneWidget);

    // Tap on the barrier.
    await tester.tapAt(const Offset(10.0, 10.0));

    // Expects that the dialog is dismissed.
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.byType(Dialog), findsNothing);

    await tester.pumpWidget(
      testWidget(
        title: 'DAC Dialog',
        description: 'This is a description.',
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.byType(Dialog), findsOneWidget);

    // Tap on the barrier.
    await tester.tapAt(const Offset(10.0, 10.0));

    // Expects that the dialog is not dismissed.
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.byType(Dialog), findsOneWidget);
  });

  testWidgets('Ensure that the icon is shown', (WidgetTester tester) async {
    await tester.pumpWidget(
      testWidget(
        icon: const Icon(
          Icons.circle_notifications,
          size: 80.0,
          color: Colors.blue,
        ),
        title: 'DAC Dialog',
        description: 'This is a description.',
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.byType(Dialog), findsOneWidget);

    // Find the icon
    expect(find.byIcon(Icons.circle_notifications), findsOneWidget);
  });

  testWidgets('Simple action button controls', (WidgetTester tester) async {
    bool isConfirmed = false;
    bool isCancelled = false;

    await tester.pumpWidget(
      testWidget(
        icon: const Icon(
          Icons.circle_notifications,
          size: 80.0,
          color: Colors.blue,
        ),
        title: 'DAC Dialog',
        description: 'This is a description.',
        onConfirm: () {
          isConfirmed = !isConfirmed;
        },
        negativeActionText: 'Cancel',
        onCancel: () {
          isCancelled = !isCancelled;
        },
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.byType(Dialog), findsOneWidget);

    // Both button is present.
    expect(find.byKey(const Key('positiveAction')), findsOneWidget);
    expect(find.byKey(const Key('negativeAction')), findsOneWidget);

    // Confirm button pressed.
    await tester.tap(find.byKey(const Key('positiveAction')));
    await tester.pump();
    expect(isConfirmed, true);
    expect(find.byType(Dialog), findsNothing);

    await tester.pumpWidget(
      testWidget(
        icon: const Icon(
          Icons.circle_notifications,
          size: 80.0,
          color: Colors.blue,
        ),
        title: 'DAC Dialog',
        description: 'This is a description.',
        onConfirm: () {
          isConfirmed = !isConfirmed;
        },
        negativeActionText: 'Cancel',
        onCancel: () {
          isCancelled = !isCancelled;
        },
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.byType(Dialog), findsOneWidget);

    // Cancel button pressed.
    await tester.tap(find.byKey(const Key('negativeAction')));
    await tester.pump();
    expect(isCancelled, true);
    expect(find.byType(Dialog), findsNothing);
  });
}
