import 'package:flutter/material.dart';

/// Creates the [PDAXDataTableRow] for [PDAXDataTable] widget.
///
/// This is extended to [DataCell] class from [DataTable].
class PDAXDataTableCell extends DataCell {
  const PDAXDataTableCell(
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
