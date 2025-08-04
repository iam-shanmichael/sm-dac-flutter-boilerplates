import 'package:flutter/material.dart';

class FileSelectionMenu extends StatelessWidget {
  const FileSelectionMenu({
    Key? key,
    required this.fileSelectText,
    required this.clearSelectionText,
    this.fileSelectTextStyle,
    this.clearSelectionTextStyle,
    required this.onSelect,
    required this.onClear,
  }) : super(key: key);

  final String fileSelectText;

  final String clearSelectionText;

  final TextStyle? fileSelectTextStyle;

  final TextStyle? clearSelectionTextStyle;

  final VoidCallback onSelect;

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
          onPressed: onSelect,
          icon: const Icon(Icons.add_circle),
          label: Text(
            fileSelectText,
            style: (fileSelectTextStyle != null)
                ? fileSelectTextStyle
                : const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
          ),
        ),
        const SizedBox(width: 8.0),
        TextButton.icon(
          onPressed: onClear,
          icon: const Icon(Icons.cancel, color: Colors.red),
          label: Text(
            clearSelectionText,
            style: (clearSelectionTextStyle != null)
                ? clearSelectionTextStyle
                : const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
          ),
        ),
      ],
    );
  }
}
