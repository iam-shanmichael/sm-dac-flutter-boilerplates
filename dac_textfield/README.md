# SM-DAC TextField

- Version: 1.0.0
- Supported platforms: Android, iOS, & Web

A customize TextField widget for SM-DAC.

## Features

- Can be used for the default textfield behavior for SM-DAC products.
- Can be used as a textfield with currency behavior.

## Installation via Github repo

Once you clone this on your local computer, add the local path of this package on the `pubspec.yaml` file of your desired project .

```yaml
dac_text_field:
  path: <PATH_ON_YOUR_LOCAL>
```

## Example

You can find a simple example in the `/example` folder, below is the code of the main.dart file:

```dart
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
            hintText: 'Hello',
            isCurrency: true,
          ),
        ),
      ),
    );
  }
}

```
