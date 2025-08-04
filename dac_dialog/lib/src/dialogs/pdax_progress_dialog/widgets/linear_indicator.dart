import 'package:flutter/material.dart';

class LinearIndicator extends StatelessWidget {
  const LinearIndicator(
    this.progressValue, {
    Key? key,
    required this.maxProgressValue,
    required this.showPercentIndicator,
    required this.strokeWidth,
    this.valueColor,
    this.backgroundColor,
    this.description,
    required this.descriptionTextAlignment,
    this.descriptionTextStyle,
    this.progressValueTextStyle,
  }) : super(key: key);

  final int progressValue;

  final int maxProgressValue;

  final bool showPercentIndicator;

  final double strokeWidth;

  final Color? valueColor;

  final Color? backgroundColor;

  final String? description;

  final TextAlign descriptionTextAlignment;

  final TextStyle? descriptionTextStyle;

  final TextStyle? progressValueTextStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        (showPercentIndicator)
            ? Text(
                '$progressValue%',
                style: (progressValueTextStyle != null)
                    ? progressValueTextStyle
                    : const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
              )
            : const SizedBox.shrink(),
        (showPercentIndicator)
            ? const SizedBox(height: 15.0)
            : const SizedBox.shrink(),
        LinearProgressIndicator(
          value: value,
          valueColor: (valueColor != null)
              ? AlwaysStoppedAnimation<Color>(valueColor!)
              : null,
          backgroundColor: backgroundColor,
          minHeight: strokeWidth,
        ),
        (description != null)
            ? const SizedBox(height: 15.0)
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
      ],
    );
  }

  double? get value =>
      (progressValue != 0) ? progressValue / maxProgressValue : null;
}
