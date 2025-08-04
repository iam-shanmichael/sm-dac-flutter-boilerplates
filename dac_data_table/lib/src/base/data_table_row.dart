import 'package:flutter/material.dart';
import 'package:dac_data_table/src/base/data_table_cell.dart';

/// Creates the [DACDataTableRow] for [DACDataTable] widget.
///
/// This is extended to [DataRow] class from [DataTable].
class DACDataTableRow extends DataRow {
  const DACDataTableRow({
    super.key,
    required List<DACDataTableCell> cells,
    super.selected,
    super.color,
    super.onSelectChanged,
    super.onLongPress,
  }) : super(cells: cells);

  const DACDataTableRow.byIndex({
    int? index,
    required List<DACDataTableCell> cells,
    super.selected,
    super.color,
    super.onSelectChanged,
    super.onLongPress,
  }) : super(cells: cells);
}
