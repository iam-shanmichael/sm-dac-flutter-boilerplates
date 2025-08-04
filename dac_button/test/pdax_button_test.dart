import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dac_button/dac_button.dart';

void main() {
  Widget testWidget({VoidCallback? onPressed, bool isEnabled = true, Icon? icon, bool isOutlined = false}) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: DACButton(
            text: 'DAC Button',
            minWidth: 350,
            width: 350,
            onPressed: onPressed,
            isEnabled: isEnabled,
            icon: icon,
            isOutlined: isOutlined,
          ),
        ),
      ),
    );
  }


  testWidgets('Ensure that Button exists', (widgetTester) async {
    await widgetTester.pumpWidget(testWidget());

    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.textContaining('DAC Button'), findsOneWidget);
  });

  testWidgets('Button can be tapped', (widgetTester) async {
    bool isTapped = false;
    await widgetTester.pumpWidget(testWidget(onPressed: (){
      isTapped = true;
    }));
    await widgetTester.tap(find.byType(ElevatedButton));

    expect(isTapped, true);
  });

  testWidgets('Button is Disabled', (widgetTester) async {
    bool isTapped = false;
    await widgetTester.pumpWidget(testWidget(onPressed: (){
      isTapped = true;
    }, isEnabled: false));
    await widgetTester.tap(find.byType(ElevatedButton));

    expect(isTapped, false);
  });

  testWidgets('Button has an icon', (widgetTester) async {
    await widgetTester.pumpWidget(testWidget(icon: const Icon(Icons.close)));

    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('Ensure that outlined button exists', (widgetTester) async {
    await widgetTester.pumpWidget(testWidget(isOutlined: true));

    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.textContaining('DAC Button'), findsOneWidget);
  });


}

