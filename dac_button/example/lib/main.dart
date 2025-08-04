import 'package:flutter/material.dart';
import 'package:dac_button/dac_button.dart';

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
      home: const MyHomePage(title: 'DAC Button Demo Home Page'),
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
              DACButton(
                  text: 'Filled Button',
                  minWidth: 350,
                  width: 350,
                  onPressed: (){

                  },
              ),
              const SizedBox(height: 15),
              DACButton(
                text: 'Disabled Button',
                isEnabled: false,
                minWidth: 350,
                width: 350,
                onPressed: (){

                },
              ),
              const SizedBox(height: 15),
              DACButton(
                text: 'Outlined Button',
                borderColor: const Color(0xFF2274E5),
                isOutlined: true,
                minWidth: 350,
                width: 350,
                onPressed: (){

                },
              ),
              const SizedBox(height: 15),
              DACButton(
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


