import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:flutter/material.dart';

/// This is the settings used for the paginator of [DACDataTable].
///
/// Usage:
///
/// ```dart
/// DACDataTable(
///   source: ExampleDataSource(),
///   columns: [...],
///   paginatorSettings: DataTablePaginatorSettings(
///     availableRowsPerPage: <int>[10, 50, 100, 200],
///     onRowsPerPageChanged: (rPP) {...}
///   ),
/// ),
/// ```
class DataTablePaginatorSettings {
  const DataTablePaginatorSettings({
    this.showFirstLastButtons = true,
    this.availableRowsPerPage = const <int>[10, 50, 100, 200],
    this.paginatorAlignment = Alignment.centerRight,
    this.onRowsPerPageChanged,
    this.getPaginatorRowText,
    this.customPaginator,
  });

  /// This is used when the user wants to show the jump to the first or last page of the [DACDataTable].
  ///
  /// Default value is `true`.
  final bool showFirstLastButtons;

  /// Sets the desired available rows per page.
  final List<int> availableRowsPerPage;

  /// Sets the alignment of the paginator.
  ///
  /// Default value is `Alignment.centerRight`.
  final Alignment paginatorAlignment;

  /// Called when the user changed the rows per page based on [DataTablePaginatorSettings.availableRowsPerPage].
  ///
  /// This will get a callback of the selected rows per page.
  final void Function(int? rowsPerPage)? onRowsPerPageChanged;

  final String Function(int, int, int?, int)? getPaginatorRowText;

  /// The user can create its own paginator.
  ///
  /// If null, the default paginator will be created.
  final Widget Function(AdvancedDataTableSource<dynamic>, int)? customPaginator;
}
