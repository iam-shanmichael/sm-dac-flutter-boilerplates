import 'package:flutter/material.dart';
import 'package:pdax_dialog/pdax_dialog.dart';
import 'package:pdax_dialog/src/dialogs/pdax_progress_dialog/widgets/circular_indicator.dart';
import 'package:pdax_dialog/src/dialogs/pdax_progress_dialog/widgets/linear_indicator.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// A widget that shows custom progress dialog box.
///
/// This is used for dowloading or uploading files to the server.
///
/// Usage:
///
/// ```dart
///  return Center(
///     child: ElevatedButton(
///       child: Text('Show Progress Dialog Button'),
///       onPressed: () {
///         PDAXProgressDialog pd = PDAXProgressDialog(context);
///
///         pd.show(
///           showPercentIndicator: true,
///           progressIndicatorBackgroundColor: Colors.grey,
///           description: 'Downloading please wait ...',
///         );
///
///         Timer.periodic(const Duration(seconds: 1), (Timer timer) {
///           setState(() {
///             if (value == 100) {
///               timer.cancel();
///
///                // This is optional. Once the progress is complete, the dialog automatically closes.
///                pd.close();
///             } else {
///               value = value + 1;
///               pd.update(value);
///             }
///           });
///         });
///       },
///     ),
///  );
/// ```
class PDAXProgressDialog {
  PDAXProgressDialog(this.context);

  final BuildContext context;

  /// This will show whether the [PDAXProgressDialog] is open.
  ///
  ///  Not directly accessible.
  bool _dialogIsOpen = false;

  /// This holds the progress and notifies when the new value is received.
  ///
  ///  Not directly accessible.
  final ValueNotifier<int> _progress = ValueNotifier(0);

  /// This will show the [PDAXProgressDialog].
  Future<void> show({
    ProgressType progressType = ProgressType.circular,
    bool isDismissible = false,
    bool showPercentIndicator = false,
    int maxProgressValue = 100,
    double strokeWidth = 4.0,
    double dialogElevation = 8.0,
    double dialogBorderRadius = 16.0,
    double dialogMinWidth = 380.0,
    Color? dialogColor,
    Color? progressIndicatorColor,
    Color? progressIndicatorBackgroundColor,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(
      horizontal: 24.0,
      vertical: 30.0,
    ),
    String? description,
    TextAlign descriptionTextAlignment = TextAlign.center,
    TextStyle? descriptionTextStyle,
    TextStyle? progressValueTextStyle,
  }) async {
    _dialogIsOpen = true;

    await showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => WillPopScope(
        onWillPop: () => Future.value(isDismissible),
        child: Dialog(
          elevation: dialogElevation,
          backgroundColor: dialogColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dialogBorderRadius),
          ),
          child: PointerInterceptor(
            child: ValueListenableBuilder<int>(
              valueListenable: _progress,
              builder: (BuildContext context, int value, Widget? child) {
                if (value == maxProgressValue) close();

                return Container(
                  width:
                      (_screenWidth >= 600.0) ? dialogMinWidth : _screenWidth,
                  padding: contentPadding,
                  child: (progressType == ProgressType.circular)
                      ? CircularIndicator(
                          value,
                          maxProgressValue: maxProgressValue,
                          showPercentIndicator: showPercentIndicator,
                          strokeWidth: strokeWidth,
                          valueColor: progressIndicatorColor,
                          backgroundColor: progressIndicatorBackgroundColor,
                          description: description,
                          descriptionTextAlignment: descriptionTextAlignment,
                          descriptionTextStyle: descriptionTextStyle,
                          progressValueTextStyle: progressValueTextStyle,
                        )
                      : LinearIndicator(
                          value,
                          maxProgressValue: maxProgressValue,
                          showPercentIndicator: showPercentIndicator,
                          strokeWidth: strokeWidth,
                          valueColor: progressIndicatorColor,
                          backgroundColor: progressIndicatorBackgroundColor,
                          description: description,
                          descriptionTextAlignment: descriptionTextAlignment,
                          descriptionTextStyle: descriptionTextStyle,
                          progressValueTextStyle: progressValueTextStyle,
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// This will update the [PDAXProgressDialog]'s progress value.
  void update(int value) => _progress.value = value;

  /// This will close the [PDAXProgressDialog].
  void close() {
    if (_dialogIsOpen) {
      Navigator.of(context, rootNavigator: true).pop();
      _dialogIsOpen = false;
    }
  }

  /// This will determine if the [PDAXProgressDialog] is open.
  bool get isOpen => _dialogIsOpen;

  double get _screenWidth => MediaQuery.of(context).size.width;
}
