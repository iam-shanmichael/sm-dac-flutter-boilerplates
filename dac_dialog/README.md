# SM-DAC Dialog

- Version: 1.0.1
- Supported platforms: Android, iOS, & Web
- Packages dependent on:
    
    - [file_picker](https://pub.dev/packages/file_picker)
    - [dotted_border](https://pub.dev/packages/dotted_border)

A widget that shows custom dialog box with different variations.

## Features
- Can add any widget for giving additional flare on your dialog.
- Can add title and description.
- Giving more controls on positive and negative action buttons.
- Added addtional dialog variations depending on your project requirements.


## Installation via Github repo
Once you clone this on your local computer, add the local path of this package on the `pubspec.yaml` file of your desired project .

```yaml
  dac_dialog: 
    path: <PATH_ON_YOUR_LOCAL>
```

## Dialog Variations
- `DACDialog`
    - Generic type of dialog, can be used for error prompts or warning.
- `DACProgressDialog`
    - Can be used on showing progress for example, uploading a file from the server or loading indicator.
- `DACFileSelectDialog` 
    - Can be used for selecting files for upload.

## Example
You can find a simple example in the `/example` folder, below is the code of the main.dart file:

```dart
import 'dart:async';
import 'package:example/widgets/dac_demo_button.dart';
import 'package:flutter/material.dart';
import 'package:DAC_dialog/DAC_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DAC Dialog Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'DAC Dialog Demo'),
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
                DACProgressDialog pd = DACProgressDialog(context);

                pd.show(
                  showPercentIndicator: true,
                  progressIndicatorBackgroundColor: Colors.grey,
                  description: 'Downloading please wait ...',
                );

                downloadData();
              },
            ),
            DACDemoButton(
              title: 'Circular Progress Dialog',
              onPressed: () {
                DACProgressDialog pd = DACProgressDialog(context);

                pd.show(
                  showPercentIndicator: true,
                  progressType: ProgressType.linear
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
}
```

## Example Usage of DACProgressDialog with Dio

If you're calling an API for download or upload, you refer to this example.

```dart
var dio = new Dio();

DACProgressDialog pd = DACProgressDialog(context);

pd.show(
  showPercentIndicator: true,
  progressIndicatorBackgroundColor: Colors.grey,
  description: 'Downloading please wait ...',
);

await dio.download(
  'your download_url',
  'your path',
  onReceiveProgress: (rec, total) {
    int progress = (((rec / total) * 100).toInt());
    pd.update(progress);
  },
);
```






