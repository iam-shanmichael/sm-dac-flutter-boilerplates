import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dac_dialog/dac_dialog.dart';

void main() {
  late DACProgressDialog pd;

  Widget testWidget() {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) => const ElevatedButton(
              onPressed: null,
              child: Text('Show Progress Dialog Button'),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('Circular progress dialog is showing',
      (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());

    final BuildContext context = tester.element(find.byType(ElevatedButton));

    pd = DACProgressDialog(context);

    pd.show(description: 'Downloading please wait ...');
    await tester.pump();

    // Circular progress dialog is present.
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Find the description
    expect(find.textContaining('Downloading please wait ...'), findsOneWidget);
  });

  testWidgets('Linear progress dialog is showing', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());

    final BuildContext context = tester.element(find.byType(ElevatedButton));

    pd = DACProgressDialog(context);

    pd.show(
      progressType: ProgressType.linear,
      description: 'Downloading please wait ...',
    );
    await tester.pump();

    // Linear progress dialog is present.
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    // Find the description
    expect(find.textContaining('Downloading please wait ...'), findsOneWidget);
  });

  testWidgets('Progress dialog dismissible test', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());

    final BuildContext context = tester.element(find.byType(ElevatedButton));

    pd = DACProgressDialog(context);

    pd.show(
      isDismissible: true,
      description: 'Downloading please wait ...',
    );
    await tester.pump();

    // Tap on the barrier.
    await tester.tapAt(const Offset(10.0, 10.0));

    // Expects that the dialog is dismissed.
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.byType(Dialog), findsNothing);

    pd.show(description: 'Downloading please wait ...');
    await tester.pump();

    // Tap on the barrier.
    await tester.tapAt(const Offset(10.0, 10.0));

    // Expects that the dialog is not dismissed.
    await tester.pump();
    expect(find.byType(Dialog), findsOneWidget);
  });

  testWidgets('Update progress test', (WidgetTester tester) async {
    int value = 0;

    await tester.pumpWidget(testWidget());

    final BuildContext context = tester.element(find.byType(ElevatedButton));

    pd = DACProgressDialog(context);

    pd.show(
      showPercentIndicator: true,
      description: 'Downloading please wait ...',
    );
    await tester.pump();

    // Circular progress dialog is present.
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Ensure it will start in zero
    expect(find.text('0%'), findsOneWidget);

    pd.update(value + 1);
    await tester.pump();

    // It will update to 1%
    expect(find.text('1%'), findsOneWidget);

    // It will update to 1%
    pd.update(value + 100);
    await tester.pump();

    // It will update to 100%
    expect(find.text('100%'), findsOneWidget);
  });
}
