import 'package:flutter/material.dart';
import 'package:dac_textfield/dac_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
}
