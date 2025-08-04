# PDAX Placeholder

- Version: 1.0.0
- Supported platforms: Android, iOS, & Web

A customize Placeholder widget for PDAX.

## Features

- Can be used for the default Placeholder behavior for PDAX products.

## Installation via Github repo

Once you clone this on your local computer, add the local path of this package on the `pubspec.yaml` file of your desired project .

```yaml
pdax_placeholder:
  path: <PATH_ON_YOUR_LOCAL>
```

## Example

You can find a simple example in the `/example` folder, below is the code of the main.dart file:

```dart
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


```
