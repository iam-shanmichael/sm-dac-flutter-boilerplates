import 'package:flutter/material.dart';

/// A widget that can be used for representing data in [PDAXDataTableCell].
///
/// Usage:
///
/// ```dart
/// class ExampleDataSource extends AdvancedDataTableSource<ExampleModel> {
///   final data = [
///     ExampleModel(index, 'John Doe', 'Developer', 20000)
///   ];
///
///   @override
///   PDAXDataTableRow? getRow(int index) {
///     final currentRowData = lastDetails!.rows[index];
///
///     return PDAXDataTableRow(
///       cells: [
///         PDAXDataTableCell(
///           PDAXDataTableCellText(currentRowData.id.toString()),
///         ),
///       ],
///     );
///   }
///
///   ...
/// }
/// ```
class PDAXDataTableCellText extends StatelessWidget {
  const PDAXDataTableCellText(
    this.data, {
    Key? key,
    this.textStyle,
  }) : super(key: key);

  final String data;

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      data,
      style: (textStyle != null)
          ? const TextStyle(
              fontSize: 14.0,
              color: Color(0xFF0A376E),
            ).merge(textStyle)
          : const TextStyle(
              fontSize: 14.0,
              color: Color(0xFF0A376E),
            ),
    );
  }
}
