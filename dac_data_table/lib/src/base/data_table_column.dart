import 'package:flutter/material.dart';

/// Creates the [DACDataTableColumn] for [DACDataTable] widget.
class DACDataTableColumn {
  DACDataTableColumn({
    required this.label,
    this.labelTextStyle,
    this.tooltip,
    this.isNumeric = false,
    this.onSort,
  });

  /// This represents the column names for [DACDataTable].
  final String label;

  /// This is used to adjust the style of the column names.
  ///
  /// If this is null, the default text style will be used.
  final TextStyle? labelTextStyle;

  /// The column heading's tooltip.
  ///
  /// This is a longer description of the column heading, for cases where the heading might have been abbreviated to keep the column width to a reasonable size.
  final String? tooltip;

  /// Whether this column represents numeric data or not.
  ///
  /// The contents of cells of columns containing numeric data are right-aligned.
  final bool isNumeric;

  /// Called when the user asks to sort the table using this column.
  ///
  /// If null, the column will not be considered sortable.
  final void Function(int, bool)? onSort;
}
