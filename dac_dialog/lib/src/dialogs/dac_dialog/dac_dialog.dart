import 'package:flutter/material.dart';
import 'package:dac_dialog/src/helpers/dialog_service.dart';
import 'package:dac_dialog/src/shared_widgets/custom_button.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

typedef OnCancelCallback = VoidCallback;

typedef OnConfirmCallback = VoidCallback;

/// A widget that shows generic dialog box.
///
/// Can be used for information and confirmation prompts.
///
/// Usage:
///
/// ```dart
///  return Center(
///     child: ElevatedButton(
///       child: Text('Show Dialog Button'),
///       onPressed: () {
///         DACDialog(
///           context,
///           icon: const Icon(
///             Icons.circle_notifications,
///             size: 80.0,
///             color: Colors.blue,
///           ),
///           title: 'This is a title',
///           positiveActionText: 'Confirm',
///           onConfirm: () => showSnackBar(
///             context,
///             text: 'Action confirmed!',
///            ),
///           negativeActionText: 'Cancel',
///           onCancel: () => showSnackBar(
///             context,
///             text: 'Action cancelled!',
///           ),
///        ).show();
///       },
///     ),
///  );
/// ```
class DACDialog implements DialogService {
  const DACDialog(
    this.context, {
    this.isDismissible = false,
    this.dialogElevation = 8.0,
    this.dialogBorderRadius = 16.0,
    this.dialogMinWidth = 380.0,
    this.actionButtonsHeight = 48.0,
    this.actionButtonBorderRadius = 16.0,
    this.dialogColor,
    this.positiveActionColor = const Color(0xFF2274E5),
    this.negativeActionBorderColor = const Color(0xFF2274E5),
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 24.0,
      vertical: 30.0,
    ),
    this.icon,
    this.title,
    this.description,
    this.positiveActionText = 'Okay',
    this.negativeActionText,
    this.descriptionTextAlignment = TextAlign.center,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.positiveActionTextStyle,
    this.negativeActionTextStyle,
    this.onConfirm,
    this.onCancel,
  });

  final BuildContext context;

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
  /// If the screen's width if greater than equal to `600.0`, the [DACDialog.dialogMinWidth] will be used.
  /// Otherwise, the dialog will adapt the screen's width.
  ///
  /// The default value is `380.0`.
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

  /// This is used to add padding on the content of the dialog.
  ///
  /// The default value is `const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0,)`
  final EdgeInsetsGeometry contentPadding;

  /// Any widget that is on top of the content.
  ///
  /// If the [DACDialog.icon] is null, it will not be shown in the dialog.
  final Widget? icon;

  final String? title;

  final String? description;

  /// This used to set the text for the positive action button.
  ///
  /// If the [DACDialog.positiveActionText] is not set, the default value will be used.
  final String positiveActionText;

  /// This used to set the text for the negative action button.
  ///
  /// If the [DACDialog.negativeActionText] is not set, the negative action button will not be shown.
  final String? negativeActionText;

  /// This used to set the alignment for the [DACDialog.description].
  ///
  /// The default value is `TextAlign.center`.
  final TextAlign descriptionTextAlignment;

  /// This used to set the text style for the [DACDialog.title].
  ///
  /// If null, the default text style will be used.
  final TextStyle? titleTextStyle;

  /// This used to set the text style for the [DACDialog.description].
  ///
  /// If null, the default text style will be used.
  final TextStyle? descriptionTextStyle;

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
  /// If null, it will close the dialog.
  final OnConfirmCallback? onConfirm;

  /// Invoked when the user tapped the negative action button.
  ///
  /// If null, it will close the dialog.
  final OnCancelCallback? onCancel;

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              (icon != null)
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: icon!,
                    )
                  : const SizedBox.shrink(),
              (title != null)
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        title!,
                        textAlign: TextAlign.center,
                        style: (titleTextStyle != null)
                            ? titleTextStyle
                            : const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                              ),
                      ),
                    )
                  : const SizedBox.shrink(),
              (description != null)
                  ? Text(
                      description!,
                      textAlign: descriptionTextAlignment,
                      style: (descriptionTextStyle != null)
                          ? descriptionTextStyle
                          : const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 25.0),
              Row(
                children: [
                  (negativeActionText != null)
                      ? Expanded(
                          child: CustomButton(
                            key: const Key('negativeAction'),
                            text: negativeActionText!,
                            textStyle: negativeActionTextStyle,
                            minHeight: actionButtonsHeight,
                            borderRadius: actionButtonBorderRadius,
                            isOutlined: true,
                            isFilled: false,
                            fillColor: Colors.transparent,
                            borderColor: negativeActionBorderColor,
                            onPressed: () {
                              close();

                              if (onCancel != null) onCancel!();
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: CustomButton(
                      key: const Key('positiveAction'),
                      text: positiveActionText,
                      textStyle: positiveActionTextStyle,
                      minHeight: actionButtonsHeight,
                      isOutlined: false,
                      borderRadius: actionButtonBorderRadius,
                      fillColor: positiveActionColor,
                      borderColor: Colors.transparent,
                      onPressed: () {
                        close();

                        if (onConfirm != null) onConfirm!();
                      },
                    ),
                  ),
                ],
              )
            ],
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
