import 'package:flutter/material.dart';
import 'package:pdax_placeholder/pdax_placeholder.dart';

class DACPlaceHolder extends StatelessWidget {
  const PDAXPlaceHolder({
    required this.hasButton,
    required this.title,
    required this.description,
    this.icon,
    this.buttonText,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.buttonTextStyle,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  /// The icon to display.
  /// The icon can be null, in which case the widget will render a placeholder
  final Widget? icon;

  /// The "title" text to display.
  final String? title;

  /// The "description" text to display.
  final String? description;

  /// The "buttonText" text to display.
  final String? buttonText;

  /// If non-null, the style to use for this [title].
  final TextStyle? titleTextStyle;

  /// If non-null, the style to use for this [description].
  final TextStyle? descriptionTextStyle;

  /// If non-null, the style to use for this [buttonText].
  final TextStyle? buttonTextStyle;

  /// If [onPressed] callback is null, then the
  /// button will be disabled.
  final VoidCallback? onPressed;

  /// if [hasButton] is true, display a button
  final bool hasButton;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            child: icon ?? const Placeholder(),
          ),
          SizedBox(
            height: DACConstants.spacerHeight * 4,
          ),
          Text(
            title ?? DACConstants.defaultTitle,
            style: titleTextStyle ?? DACConstants.defaultTitleTextStyle,
          ),
          SizedBox(
            height: DACConstants.spacerHeight,
          ),
          Text(
            description ?? DACConstants.defaultDescription,
            style: descriptionTextStyle ?? DACConstants.defaultDescriptionTextStyle,
          ),
          if (hasButton)
            Column(
              children: [
                SizedBox(
                  height: DACConstants.spacerHeight * 4,
                ),
                ElevatedButton(
                  onPressed: onPressed,
                  child: Text(
                    buttonText ?? DACConstants.defaultButtonText,
                    style: buttonTextStyle ?? DACConstants.defaultButtonTextStyle,
                  ),
                )
              ],
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
