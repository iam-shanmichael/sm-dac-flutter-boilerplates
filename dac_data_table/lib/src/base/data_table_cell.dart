import 'package:flutter/material.dart';

/// Creates the [DACDataTableRow] for [DACDataTable] widget.
///
/// This is extended to [DataCell] class from [DataTable].
class DACDataTableCell extends DataCell {
  const DACDataTableCell(
    super.child, {
    super.placeholder,
    super.showEditIcon,
    super.onTap,
    super.onLongPress,
    super.onTapDown,
    super.onDoubleTap,
    super.onTapCancel,
  });
}
