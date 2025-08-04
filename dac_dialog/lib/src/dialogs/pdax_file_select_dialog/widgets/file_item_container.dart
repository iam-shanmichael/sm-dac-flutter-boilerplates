import 'package:flutter/material.dart';

class FileItemContainer extends StatelessWidget {
  const FileItemContainer({
    Key? key,
    required this.name,
    required this.borderColor,
    this.padding = const EdgeInsets.all(8.0),
    required this.onUnselect,
  }) : super(key: key);

  final String name;

  final Color borderColor;

  final EdgeInsets padding;

  final VoidCallback onUnselect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: onUnselect,
              child: const Icon(
                Icons.close_rounded,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
