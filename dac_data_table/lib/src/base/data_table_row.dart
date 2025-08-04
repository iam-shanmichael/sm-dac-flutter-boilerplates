import 'package:flutter/material.dart';
import 'package:pdax_data_table/src/base/data_table_cell.dart';

/// Creates the [PDAXDataTableRow] for [PDAXDataTable] widget.
///
/// This is extended to [DataRow] class from [DataTable].
class PDAXDataTableRow extends DataRow {
  const PDAXDataTableRow({
    super.key,
    required List<PDAXDataTableCell> cells,
    super.selected,
    super.color,
    super.onSelectChanged,
    super.onLongPress,
  }) : super(cells: cells);

  const PDAXDataTableRow.byIndex({
    int? index,
    required List<PDAXDataTableCell> cells,
    super.selected,
    super.color,
    super.onSelectChanged,
    super.onLongPress,
  }) : super(cells: cells);
}
