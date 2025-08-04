import 'package:pdax_data_table/pdax_data_table.dart';

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
  PDAXDataTableRow? getRow(int index) {
    final cells = [
      PDAXDataTableCell(
        PDAXDataTableCellText((lastOffset + index).toString()),
      ),
    ];
    if (twoColumn) {
      cells.add(
        const PDAXDataTableCell(
          PDAXDataTableCellText('Column two'),
        ),
      );
    }

    return PDAXDataTableRow(cells: cells);
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
