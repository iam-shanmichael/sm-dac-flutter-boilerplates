import 'dart:async';
import 'package:example/widgets/dac_demo_button.dart';
import 'package:flutter/material.dart';
import 'package:dac_dialog/dac_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SM-DAC Dialog Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SM-DAC Dialog Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DACProgressDialog pd;

  int value = 0;

  @override
  void initState() {
    pd = DACProgressDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DACDemoButton(
              title: 'Generic Dialog',
              onPressed: () {
                DACDialog(
                  context,
                  title: 'This is a title',
                ).show();
              },
            ),
            DACDemoButton(
              title: 'Dialog with Icon',
              onPressed: () {
                DACDialog(
                  context,
                  icon: const Icon(
                    Icons.circle_notifications,
                    size: 80.0,
                    color: Colors.blue,
                  ),
                  title: 'This is a title',
                ).show();
              },
            ),
            DACDemoButton(
              title: 'Confirmation Dialog',
              onPressed: () {
                DACDialog(
                  context,
                  icon: const Icon(
                    Icons.circle_notifications,
                    size: 80.0,
                    color: Colors.blue,
                  ),
                  title: 'This is a title',
                  positiveActionText: 'Confirm',
                  onConfirm: () => showSnackBar(
                    context,
                    text: 'Action confirmed!',
                  ),
                  negativeActionText: 'Cancel',
                  onCancel: () => showSnackBar(
                    context,
                    text: 'Action cancelled!',
                  ),
                ).show();
              },
            ),
            DACDemoButton(
              title: 'Circular Progress Dialog',
              onPressed: () {
                pd.show(
                  showPercentIndicator: true,
                  progressIndicatorBackgroundColor: Colors.grey,
                  description: 'Downloading please wait ...',
                );

                downloadData();
              },
            ),
            DACDemoButton(
              title: 'Linear Progress Dialog',
              onPressed: () {
                pd.show(
                  progressType: ProgressType.linear,
                  showPercentIndicator: true,
                  progressIndicatorBackgroundColor: Colors.grey,
                  description: 'Downloading please wait ...',
                );

                downloadData();
              },
            ),
            DACDemoButton(
              title: 'File Upload Dialog',
              onPressed: () {
                DACFileSelectDialog(
                  context,
                  title: 'Upload Balance Correction',
                  supportedFormats: [FileFormat.csv, FileFormat.jpg],
                  allowMultiple: false,
                  onUpload: (List<SelectedFile> selectedFiles) {
                    showSnackBar(
                      context,
                      text: 'Uploaded ${selectedFiles.length} files!',
                    );

                    Navigator.pop(context);
                  },
                ).show();
              },
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, {required String text}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void downloadData() {
    value = 0;

    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (value == 100) {
          timer.cancel();
        } else {
          value = value + 1;

          pd.update(value);
        }
      });
    });
  }
}
