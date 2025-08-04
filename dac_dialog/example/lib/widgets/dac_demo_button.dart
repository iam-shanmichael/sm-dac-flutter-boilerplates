import 'package:flutter/material.dart';

class DACDemoButton extends StatelessWidget {
  const DACDemoButton({
    Key? key,
    required this.onPressed,
    this.title,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title ?? 'DAC Demo'),
      ),
    );
  }
}
