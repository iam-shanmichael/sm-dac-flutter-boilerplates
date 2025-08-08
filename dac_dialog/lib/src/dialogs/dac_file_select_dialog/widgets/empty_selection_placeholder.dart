import 'package:flutter/material.dart';

class EmptySelectionPlaceholder extends StatelessWidget {
  const EmptySelectionPlaceholder({
    Key? key,
    required this.text,
    this.textStyle,
  }) : super(key: key);

  final String text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: (textStyle != null)
                ? textStyle
                : TextStyle(
                    fontSize: 16.0,
                    color: const Color(0xFF2274E5).withValues(alpha: 0.60),
                    fontWeight: FontWeight.w800,
                  ),
          ),
        ),
      ],
    );
  }
}
