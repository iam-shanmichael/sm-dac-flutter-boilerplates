import 'package:dac_data_table/dac_data_table.dart';
import 'package:flutter/material.dart';

class TestData {
  final int index;

  TestData(this.index);
}

class TestSource extends AdvancedDataTableSource<TestData> {
  static int totalRows = 100;
  int lastOffset = 0;
  final bool twoColumn;

  TestSource({
    this.twoColumn = false,
  });

  void forceReload() {
    forceRemoteReload = true;
  }

  void triggerListeners() {
    notifyListeners();
  }

  @override
  DACDataTableRow? getRow(int index) {
    final cells = [
      DACDataTableCell(
        Text((lastOffset + index).toString()),
      ),
      
    ];
    if (twoColumn) {
      cells.add(
        const DACDataTableCell(
          DACDataTableCellText('Column two'),
        ),
      );
    }

    return DACDataTableRow(cells: cells);
  }

  DateTime? lastLoad;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<TestData>> getNextPage(
    NextPageRequest pageRequest,
  ) async {
    lastOffset = pageRequest.offset;
    lastLoad = DateTime.now();
    return RemoteDataSourceDetails<TestData>(
      totalRows,
      List<TestData>.generate(pageRequest.pageSize, (index) => TestData(index)),
    );
  }
}
