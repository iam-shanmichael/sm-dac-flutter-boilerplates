import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pdax_data_table/pdax_data_table.dart';

/// A widget that uses Flutter [PaginatedDataTable] widget and allowing pagination
/// for server side responses.
///
/// This is also dependent to `advanced_datatable` package.
/// * <https://pub.dev/packages/advanced_datatable>
///
/// Usage:
///
/// ```dart
///  return SingleChildScrollView(
///     child: Column(
///       children: [
///         PDAXDataTable(
///          rowsPerPage: 10,
///           source: ExampleDataSource(),
///           columns: [
///             PDAXDataTableColumn(label: 'ID'),
///             PDAXDataTableColumn(label: 'Name'),
///           ],
///           paginatorSettings: DataTablePaginatorSettings(
///             availableRowsPerPage: <int>[10, 50, 100, 200],
///             onRowsPerPageChanged: (rPP) {...},
///           ),
///         ),
///       ],
///     ),
///  );
/// ```
class DACDataTable extends StatelessWidget {
  const DACDataTable({
    Key? key,
    required this.source,
    required this.columns,
    this.showCheckboxColumn = false,
    this.showHorizontalScrollbarAlways = true,
    this.sortAscending = true,
    this.addEmptyRows = true,
    this.rowsPerPage = 10,
    this.columnToSort,
    this.initialRowIndex = 0,
    this.dataRowHeight = kMinInteractiveDimension,
    this.headingRowHeight = 56.0,
    this.horizontalMargin = 24.0,
    this.checkboxHorizontalMargin,
    this.columnSpacing = 56.0,
    this.dragStartBehavior = DragStartBehavior.start,
    this.onSelectAll,
    this.onPageChanged,
    this.loadingWidget,
    this.errorWidget,
    this.paginatorSettings = const DataTablePaginatorSettings(),
  })  : assert(rowsPerPage != double.nan),
        super(key: key);

  /// The data source which provides data to show in each row.
  ///
  /// This is `required`.
  final AdvancedDataTableSource<dynamic> source;

  /// The configuration and labels for the columns in the table.
  ///
  /// This is `required`.
  final List<DACDataTableColumn> columns;

  /// This is used when the user want to have checkboxes on each row.
  ///
  /// Make sure that the [DACDataTableRow.onSelectChanged] is not null, otherwise the checkbox will still not be shown.
  ///
  /// The default value is `false`.
  final bool showCheckboxColumn;

  /// This used to show the horizontal scroll bar.
  ///
  /// The default value is `true`.
  final bool showHorizontalScrollbarAlways;

  /// Whether the column mentioned in [DACDataTable.columnToSort], if any, is sorted in ascending order.
  ///
  /// The default value is `true`.
  final bool sortAscending;

  /// Add empty/blank lines to the data table if not enough records are present.
  ///
  /// If the source doesnt have enough data, it will add an empty/blank lines to fill a page.
  ///
  /// The default value is `true`.
  final bool addEmptyRows;

  /// The number of rows to show on each page.
  ///
  /// This must be equal to the first item of [DataTablePaginatorSettings.availableRowsPerPage]
  ///
  /// The default value is `10`.
  final int rowsPerPage;

  /// The current primary sort key's column.
  final int? columnToSort;

  /// The index of the first row to display when the widget is first created.
  ///
  /// The default value is `0`.
  final int? initialRowIndex;

  /// The height of each row (excluding the row that contains column headings).
  ///
  /// This value is optional and defaults to `kMinInteractiveDimension` if not specified.
  final double dataRowHeight;

  /// The height of the heading row.
  ///
  /// This value is optional and defaults to `56.0` if not specified.
  final double headingRowHeight;

  /// The horizontal margin between the edges of the table and the content
  /// in the first and last cells of each row.
  ///
  /// When a checkbox is displayed, it is also the margin between the checkbox
  /// the content in the first data column.
  ///
  /// This value defaults to `24.0` to adhere to the Material Design specifications.
  ///
  /// If [DACDataTable.checkboxHorizontalMargin] is null, then [DACDataTable.checkboxHorizontalMargin] is also the
  /// margin between the edge of the table and the checkbox, as well as the
  /// margin between the checkbox and the content in the first data column.
  final double horizontalMargin;

  /// Horizontal margin around the checkbox, if it is displayed.
  ///
  /// If null, then [DACDataTable.horizontalMargin] is used as the margin between the edge
  /// of the table and the checkbox, as well as the margin between the checkbox
  /// and the content in the first data column. This value defaults to `24.0`.
  final double? checkboxHorizontalMargin;

  /// The horizontal margin between the contents of each data column.
  ///
  /// This value defaults to 56.0 to adhere to the Material Design specifications.
  final double columnSpacing;

  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], scrolling drag behavior will begin at the position where the drag gesture won the arena. If set to [DragStartBehavior.down] it will begin at the position where a down event is first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag animation smoother and setting it to [DragStartBehavior.down] will make drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  final DragStartBehavior dragStartBehavior;

  /// Invoked when the user selects or unselects every row, using the
  /// checkbox in the heading row.
  final void Function(bool?)? onSelectAll;

  /// Invoked when the user switches to another page.
  ///
  /// The value is the index of the first row on the currently displayed page.
  final void Function(int)? onPageChanged;

  /// Called while the page is loading.
  ///
  /// If not set, a default loading will be shown
  final Widget Function()? loadingWidget;

  /// Called once the page loading encountered an error in the future.
  ///
  /// If not provided a default message will be shown.
  final Widget Function()? errorWidget;

  final DataTablePaginatorSettings paginatorSettings;

  @override
  Widget build(BuildContext context) {
    return AdvancedPaginatedDataTable(
      source: source,
      addEmptyRows: addEmptyRows,
      showCheckboxColumn: showCheckboxColumn,
      sortAscending: sortAscending,
      showHorizontalScrollbarAlways: showHorizontalScrollbarAlways,
      rowsPerPage: rowsPerPage,
      initialFirstRowIndex: initialRowIndex,
      sortColumnIndex: columnToSort,
      dataRowHeight: dataRowHeight,
      headingRowHeight: headingRowHeight,
      horizontalMargin: horizontalMargin,
      checkboxHorizontalMargin: checkboxHorizontalMargin,
      columnSpacing: columnSpacing,
      dragStartBehavior: dragStartBehavior,
      onSelectAll: onSelectAll,
      onPageChanged: onPageChanged,
      defaultFootAlignment: paginatorSettings.paginatorAlignment,
      availableRowsPerPage: paginatorSettings.availableRowsPerPage,
      onRowsPerPageChanged: paginatorSettings.onRowsPerPageChanged,
      showFirstLastButtons: paginatorSettings.showFirstLastButtons,
      getFooterRowText: paginatorSettings.getPaginatorRowText,
      customTableFooter: paginatorSettings.customPaginator,
      loadingWidget: loadingWidget ??
          () => const Center(child: CircularProgressIndicator()),
      errorWidget: errorWidget,
      columns: columns
          .map<DataColumn>(
            (c) => DataColumn(
              label: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  c.label,
                  style: (c.labelTextStyle != null)
                      ? const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A376E),
                        ).merge(c.labelTextStyle)
                      : const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A376E),
                        ),
                ),
              ),
              tooltip: c.tooltip,
              numeric: c.isNumeric,
              onSort: c.onSort,
            ),
          )
          .toList(),
    );
  }
}
