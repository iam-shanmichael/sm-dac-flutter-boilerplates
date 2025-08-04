# PDAX Button

- Version: 1.0.0
- Supported platforms: Android, iOS, & Web

A customize Button widget for PDAX.

## Features

- Can be used for the default button behavior for PDAX products.
- Can be used for customise button for PDAX products.

## Installation via Github repo

Once you clone this on your local computer, add the local path of this package on the `pubspec.yaml` file of your desired project .

```yaml
pdax_button:
  path: <PATH_ON_YOUR_LOCAL>
```

## Example

You can find a simple example in the `/example` folder, below is the code of the main.dart file:

```dart
import 'package:flutter/material.dart';
import 'package:pdax_button/pdax_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'PDAX Button Demo Home Page'),
    );
  }
}
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PDAXButton(
                  text: 'Filled Button',
                  minWidth: 350,
                  width: 350,
                  onPressed: (){

                  },
              ),
              const SizedBox(height: 15),
              PDAXButton(
                text: 'Disabled Button',
                isEnabled: false,
                minWidth: 350,
                width: 350,
                onPressed: (){

                },
              ),
              const SizedBox(height: 15),
              PDAXButton(
                text: 'Outlined Button',
                borderColor: const Color(0xFF2274E5),
                isOutlined: true,
                minWidth: 350,
                width: 350,
                onPressed: (){

                },
              ),
              const SizedBox(height: 15),
              PDAXButton(
                text: 'Button with Icon',
                icon: const Icon(Icons.accessibility_new_sharp),
                minWidth: 350,
                width: 350,
                onPressed: (){

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
