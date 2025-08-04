import 'package:flutter/material.dart';
import 'package:pdax_placeholder/pdax_placeholder.dart';

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
        body: Column(
          children: [
            PDAXPlaceHolder(
              icon: const Icon(Icons.abc, size: 300),
              title: PDAXConstants.defaultTitle,
              description: PDAXConstants.defaultDescription,
              hasButton: true,
            ),
          ],
        ),
      ),
    );
  }
}
