import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dac_dialog/dac_dialog.dart';

import 'test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget testWidget({
    bool isDismissible = false,
    String? title,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) => ElevatedButton(
              child: const Text('Show File Select Dialog Button'),
              onPressed: () {
                DACFileSelectDialog(
                  context,
                  title: title,
                  isDismissible: isDismissible,
                  supportedFormats: [FileFormat.csv, FileFormat.jpg],
                  allowMultiple: false,
                  onUpload: (List<SelectedFile> selectedFiles) {
                    Navigator.pop(context);
                  },
                ).show();
              },
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('File select dialog is showing', (WidgetTester tester) async {
    await tester.pumpWidget(
      testWidget(title: 'PDAX File Select Dialog'),
    );
    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.byType(Dialog), findsOneWidget);

    // Find the title
    expect(find.textContaining('PDAX File Select Dialog'), findsOneWidget);

    // Find the file selection menus
    expect(find.textContaining('Select Files'), findsOneWidget);
    expect(find.textContaining('Clear Selection'), findsOneWidget);

    // All action buttons is present
    expect(find.byKey(const Key('positiveAction')), findsOneWidget);
    expect(find.byKey(const Key('negativeAction')), findsOneWidget);
  });

  testWidgets('File select dialog dismissible test',
      (WidgetTester tester) async {
    // This will ignore overflow error
    FlutterError.onError = ignoreOverflowErrors;

    await tester.pumpWidget(
      testWidget(isDismissible: true, title: 'PDAX File Select Dialog'),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.byType(Dialog), findsOneWidget);

    // Tap on the barrier.
    await tester.tapAt(const Offset(10.0, 10.0));

    // Expects that the dialog is dismissed.
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.byType(Dialog), findsNothing);

    await tester.pumpWidget(testWidget(title: 'PDAX File Select Dialog'));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.byType(Dialog), findsOneWidget);

    // Tap on the barrier.
    await tester.tapAt(const Offset(10.0, 10.0));

    // Expects that the dialog is not dismissed.
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.byType(Dialog), findsOneWidget);
  });
}
