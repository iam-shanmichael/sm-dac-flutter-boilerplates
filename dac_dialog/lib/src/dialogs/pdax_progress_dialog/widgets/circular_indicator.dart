import 'package:flutter/material.dart';

class CircularIndicator extends StatelessWidget {
  const CircularIndicator(
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: 1.5,
                child: CircularProgressIndicator(
                  value: value,
                  valueColor: (valueColor != null)
                      ? AlwaysStoppedAnimation<Color>(valueColor!)
                      : null,
                  backgroundColor: backgroundColor,
                  strokeWidth: strokeWidth,
                ),
              ),
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
            ],
          ),
        ),
        (description != null)
            ? const SizedBox(width: 15.0)
            : const SizedBox.shrink(),
        (description != null)
            ? Expanded(
                flex: 3,
                child: Text(
                  description!,
                  textAlign: descriptionTextAlignment,
                  style: (descriptionTextStyle != null)
                      ? descriptionTextStyle
                      : const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  double? get value =>
      (progressValue != 0) ? progressValue / maxProgressValue : null;
}
