import 'package:flutter/material.dart';
import 'package:pdax_dialog/pdax_dialog.dart';
import 'package:pdax_dialog/src/helpers/dialog_service.dart';
import 'package:pdax_dialog/src/dialogs/pdax_file_select_dialog/widgets/file_select_body.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

typedef OnUploadCallback = ValueChanged<List<SelectedFile>>;

typedef OnCancelUploadCallback = VoidCallback;

/// A widget that shows custom file selection dialog box.
///
/// Usage:
///
/// ```dart
///  return Center(
///     child: ElevatedButton(
///       child: Text('Show Progress Dialog Button'),
///       onPressed: () {
///         PDAXFileSelectDialog(
///           context,
///           title: 'Upload Balance Correction',
///           supportedFormats: [FileFormat.csv, FileFormat.jpg],
///           onUpload: (List<SelectedFile> selectedFiles) {
///             // Process uploading to your backend service.
///           },
///         ).show();
///       },
///     ),
///  );
/// ```
class PDAXFileSelectDialog implements DialogService {
  const PDAXFileSelectDialog(
    this.context, {
    this.supportedFormats,
    this.withData = true,
    this.allowMultiple = true,
    this.isDismissible = false,
    this.dialogElevation = 8.0,
    this.dialogBorderRadius = 16.0,
    this.dialogMinWidth = 490.0,
    this.actionButtonsHeight = 48.0,
    this.actionButtonBorderRadius = 16.0,
    this.dialogColor,
    this.positiveActionColor = const Color(0xFF2274E5),
    this.negativeActionBorderColor = const Color(0xFF2274E5),
    this.browsePlaceholderBorderColor = const Color(0xFF2274E5),
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 24.0,
      vertical: 30.0,
    ),
    this.title,
    this.positiveActionText = 'Upload',
    this.negativeActionText = 'Cancel',
    this.fileSelectText = 'Select Files',
    this.clearSelectionText = 'Clear Selection',
    this.browsePlaceholderText = 'Browse Files',
    this.titleTextStyle,
    this.fileSelectTextStyle,
    this.clearSelectionTextStyle,
    this.browsePlaceholderTextStyle,
    this.positiveActionTextStyle,
    this.negativeActionTextStyle,
    required this.onUpload,
    this.onCancel,
  });

  final BuildContext context;

  /// Sets the supported formats for file picker.
  ///
  /// If `null`, the user can select any files.
  final List<FileFormat>? supportedFormats;

  /// If [withData] is set, picked files will have its byte data immediately available on memory as `Uint8List`
  /// which can be useful if you are picking it for server upload or similar. However, have in mind that
  /// enabling this on IO (iOS & Android) may result in out of memory issues if you allow multiple picks or
  /// pick huge files. Use [withReadStream] instead. Defaults to `true` on web, `false` otherwise.
  final bool withData;

  /// Allow multiple selection of file,
  ///
  /// The default value is `true`.
  final bool allowMultiple;

  /// Determines whether the dialog must be closed when tapping outside the dialog.
  ///
  /// The default value is `false`.
  final bool isDismissible;

  /// This is used to increase or decrease the elevation of the dialog.
  ///
  /// The default value is `8.0`.
  final double dialogElevation;

  /// This is used to add border radius to the dialog.
  ///
  /// The default value is `16.0`.
  final double dialogBorderRadius;

  /// This is used to set the minimum width of the dialog.
  ///
  /// If the screen's width if greater than equal to `600.0`, the [PDAXDialog.dialogMinWidth] will be used.
  /// Otherwise, the dialog will adapt the screen's width.
  ///
  /// The default value is `490.0`.
  final double dialogMinWidth;

  /// This is used to set the height of the action buttons.
  ///
  /// The default value is `48.0`.
  final double actionButtonsHeight;

  /// This is used to add the border radius to the action buttons.
  ///
  /// The default value is `16.0`.
  final double actionButtonBorderRadius;

  /// This is used to change background color of the dialog.
  ///
  /// If the color is not set, the default background color will be used.
  final Color? dialogColor;

  /// This is used to change the background color of positive action button.
  ///
  /// If the color is not set, the default background color will be used.
  final Color positiveActionColor;

  /// This is used to change the outlined border color of negative action button.
  ///
  /// If the color is not set, the default border color will be used.
  final Color negativeActionBorderColor;

  final Color browsePlaceholderBorderColor;

  /// This is used to add padding on the content of the dialog.
  ///
  /// The default value is `const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0,)`
  final EdgeInsetsGeometry contentPadding;

  final String? title;

  /// This used to set the text for the positive action button.
  ///
  /// If the [PDAXFileSelectDialog.positiveActionText] is not set, the default value will be used.
  final String positiveActionText;

  /// This used to set the text for the negative action button.
  ///
  /// If the [PDAXFileSelectDialog.negativeActionText] is not set, the negative action button will not be shown.
  final String negativeActionText;

  /// This used to set the text for the selecting files.
  ///
  /// If the [PDAXFileSelectDialog.fileSelectText] is not set, the default value will be used.
  final String fileSelectText;

  /// This used to set the text for the clearing selected files.
  ///
  /// If the [PDAXFileSelectDialog.clearSelectionText] is not set, the default value will be used.
  final String clearSelectionText;

  /// This used to set the text for the browsing files placeholder.
  ///
  /// If the [PDAXFileSelectDialog.browsePlaceholderText] is not set, the default value will be used.
  final String browsePlaceholderText;

  /// This used to set the text style for the [PDAXFileSelectDialog.title].
  ///
  /// If null, the default text style will be used.
  final TextStyle? titleTextStyle;

  /// This used to set the text style for the [PDAXFileSelectDialog.fileSelectText].
  ///
  /// If null, the default text style will be used.
  final TextStyle? fileSelectTextStyle;

  /// This used to set the text style for the [PDAXFileSelectDialog.clearSelectionText].
  ///
  /// If null, the default text style will be used.
  final TextStyle? clearSelectionTextStyle;

  /// This used to set the text style for the [PDAXFileSelectDialog.browsePlaceholderText].
  ///
  /// If null, the default text style will be used.
  final TextStyle? browsePlaceholderTextStyle;

  /// This used to set the text style for the positive action button.
  ///
  /// If null, the default text style will be used.
  final TextStyle? positiveActionTextStyle;

  /// This used to set the text style for the negative action button.
  ///
  /// If null, the default text style will be used.
  final TextStyle? negativeActionTextStyle;

  /// Invoked when the user tapped the positive action button.
  ///
  /// It will return a `null` or `List<SelectedFile>`.
  final OnUploadCallback onUpload;

  /// Invoked when the user tapped the negative action button.
  ///
  /// If null, it will close the dialog.
  final OnCancelUploadCallback? onCancel;

  @override
  Widget buildDialog() {
    return Dialog(
      elevation: dialogElevation,
      backgroundColor: dialogColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dialogBorderRadius),
      ),
      child: PointerInterceptor(
        child: Container(
          width: (_screenWidth >= 600.0) ? dialogMinWidth : _screenWidth,
          padding: contentPadding,
          child: FileSelectBody(
            supportedFormats: supportedFormats,
            withData: withData,
            allowMultiple: allowMultiple,
            title: title,
            titleTextStyle: titleTextStyle,
            positiveActionText: positiveActionText,
            negativeActionText: negativeActionText,
            positiveActionColor: positiveActionColor,
            negativeActionBorderColor: negativeActionBorderColor,
            fileSelectText: fileSelectText,
            fileSelectTextStyle: fileSelectTextStyle,
            clearSelectionText: clearSelectionText,
            clearSelectionTextStyle: clearSelectionTextStyle,
            browsePlaceholderText: browsePlaceholderText,
            browsePlaceholderTextStyle: browsePlaceholderTextStyle,
            browsePlaceholderBorderColor: browsePlaceholderBorderColor,
            actionButtonsHeight: actionButtonsHeight,
            actionButtonBorderRadius: actionButtonBorderRadius,
            onUpload: onUpload,
            onCancel: onCancel,
            onClose: close,
          ),
        ),
      ),
    );
  }

  double get _screenWidth => MediaQuery.of(context).size.width;

  @override
  Future<void> show() async {
    await showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => buildDialog(),
    );
  }

  @override
  void close() => Navigator.of(context, rootNavigator: true).pop();
}
