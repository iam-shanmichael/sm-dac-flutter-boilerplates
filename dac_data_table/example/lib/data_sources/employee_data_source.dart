import 'package:example/models/employee.dart';
import 'package:dac_data_table/pdax_data_table.dart';

class EmployeeDataSource extends AdvancedDataTableSource<Employee> {
  final data = List<Employee>.generate(
    13,
    (index) => Employee(index, 'Employee 0$index', 'Developer', 20000),
  );

  @override
  int get selectedRowCount => 0;

  @override
  PDAXDataTableRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];

    return PDAXDataTableRow(
      onSelectChanged: (value) {},
      cells: [
        DACDataTableCell(
          DACDataTableCellText(currentRowData.id.toString()),
        ),
        DACDataTableCell(
          DACDataTableCellText(currentRowData.name.toString()),
        ),
        DACDataTableCell(
          DACDataTableCellText(currentRowData.designation.toString()),
        ),
        DACDataTableCell(
          DACDataTableCellText(currentRowData.salary.toString()),
        ),
      ],
    );
  }

  @override
  Future<RemoteDataSourceDetails<Employee>> getNextPage(
    NextPageRequest pageRequest,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    return RemoteDataSourceDetails(
      data.length,
      data.skip(pageRequest.offset).take(pageRequest.pageSize).toList(),
    );
  }
}
