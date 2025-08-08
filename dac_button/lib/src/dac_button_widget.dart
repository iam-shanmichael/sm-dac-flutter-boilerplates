/*
*******************************************************************
* @Copyright         : 2025 DAC Button
* @File Name         : dac_button.dart
* @Description       : SM-DAC button boilerplate widget
* @Author            : SM-DAC
*******************************************************************
*/

library dac_button;
import 'package:flutter/material.dart';

class DACButton extends StatelessWidget {
  const DACButton({
    Key? key,
    required this.text,
    this.icon,
    this.fillColor = const Color(0xFF2274E5),
    this.textColor = Colors.white,
    this.disabledTextColor = const Color(0xFFBCC4CD),
    this.outlinedTextColor = const Color(0xFF2274E5),
    this.borderColor = const Color(0xFF80D9FF),
    this.borderSize = 3.0,
    this.textStyle,
    this.isFilled = true,
    this.isEnabled = true,
    this.onPressed,
    this.borderRadius = 6.0,
    this.minWidth = double.infinity,
    this.minHeight = 60.0,
    this.height = double.infinity,
    this.width = double.infinity,
    this.elevation = 0.0,
    this.padding = const EdgeInsets.symmetric(vertical: 20.0),
    this.isOutlined = false,
  }) : super(key: key);

  /// The text inside the button.
  final String text;

  /// Icon left side of text inside the button.
  final Icon? icon;

  /// The fill color of the button if [isFilled] is set to `true`.
  final Color fillColor;

  /// The color of the text inside the button.
  ///
  /// [textStyle] must be null, otherwise [textStyle]'s [color] will be used.
  ///
  /// If [isFilled] is set to `true` it default to `white` color.
  final Color textColor;

  /// The color of the text inside the button when `disabled`.
  final Color disabledTextColor;

  /// The color of the text inside the button when `outlined`.
  final Color outlinedTextColor;

  /// The color of the border if [isFilled] is set to `false`.
  final Color borderColor;

  /// The size of the border if [isFilled] is set to `false`.
  final double borderSize;

  /// The border radius of the button.
  final double borderRadius;

  /// The style of the text inside the button
  final TextStyle? textStyle;

  /// If `true` the style of the button is filled with [fillColor].
  ///
  /// If `false` the background is transparent and has [border]
  final bool isFilled;

  /// If `false` the style will change and onTap function will do nothing.
  final bool isEnabled;

  /// The minimum width of the button.
  final double minWidth;

  /// The minimum height of the button.
  final double minHeight;

  /// The fixed width of the button
  final double width;

  /// The fixed height of the button.
  final double height;

  /// The elevation of the button.
  final double elevation;

  /// The padding of the button.
  final EdgeInsetsGeometry padding;

  /// The event called when button is pressed.
  final VoidCallback? onPressed;

  /// If `true` the button will become outlined.
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    return (!isOutlined) ? _buildDefaultButton() : _buildOutlinedButton();
  }

  Widget _buildDefaultButton() {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all<Size?>(
          Size(minWidth, minHeight),
        ),
        fixedSize: WidgetStateProperty.all<Size?>(
          Size(width, height),
        ),
        elevation: WidgetStateProperty.all<double?>(elevation),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(padding),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          getBackgroundColor,
        ),
        shape: WidgetStateProperty.resolveWith(getFocusBorder),
      ),
      onPressed: (isEnabled) ? onPressed : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           (icon != null) ? icon! : const SizedBox.shrink(),
           (icon != null)  ? const SizedBox(width: 13.0) : const SizedBox.shrink(),
          Text(
            text,
            style: textStyle?.copyWith(
              color: (isEnabled) ? textStyle?.color : disabledTextColor,
            ) ??
                TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: (isEnabled)
                      ? (isFilled)
                      ? textColor
                      : fillColor
                      : disabledTextColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedButton() {
    return OutlinedButton(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all<Size?>(
          Size(minWidth, minHeight),
        ),
        fixedSize: WidgetStateProperty.all<Size?>(
          Size(width, height),
        ),
        elevation: WidgetStateProperty.all<double?>(elevation),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(padding),
        backgroundColor: WidgetStateProperty.all<Color?>((isOutlined) ? Colors.transparent : fillColor ),
        side: WidgetStateProperty.resolveWith<BorderSide?>(
          getOutlineBorderColor,
        ),
        shape: WidgetStateProperty.all<OutlinedBorder?>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      onPressed: (isEnabled) ? onPressed : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (icon != null) ? icon! : const SizedBox.shrink(),
          (icon != null)  ? const SizedBox(width: 13.0) : const SizedBox.shrink(),
          Text(
            text,
            style: textStyle?.copyWith(
              color: (isEnabled) ? textStyle?.color : disabledTextColor,
            ) ??
                TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: (isEnabled) ? outlinedTextColor : disabledTextColor,
                ),
          ),
        ],
      ),
    );
  }

  OutlinedBorder? getFocusBorder(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: isFilled
            ? BorderSide(color: borderColor, width: borderSize)
            : BorderSide.none,
      );
    }

    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  Color? getBackgroundColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.disabled,
    };

    if (states.any(interactiveStates.contains)) {
      return isFilled ? const Color(0xFFE9EBEE) : Colors.transparent;
    }

    return isFilled ? fillColor : Colors.transparent;
  }

  BorderSide? getOutlineBorderColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.disabled,
    };

    if (states.any(interactiveStates.contains)) {
      return BorderSide(width: borderSize, color: const Color(0xFFE9EBEE));
    }

    return BorderSide(width: borderSize, color: borderColor);
  }
}
