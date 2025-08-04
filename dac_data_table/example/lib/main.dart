import 'package:example/data_sources/employee_data_source.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pdax_data_table/pdax_data_table.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PDAXDataTable(
              showCheckboxColumn: true,
              addEmptyRows: false,
              rowsPerPage: rowsPerPage,
              source: EmployeeDataSource(),
              columns: [
                PDAXDataTableColumn(label: 'ID'),
                PDAXDataTableColumn(label: 'Name'),
                PDAXDataTableColumn(label: 'Designation'),
                PDAXDataTableColumn(label: 'Salary'),
              ],
              paginatorSettings: DataTablePaginatorSettings(
                availableRowsPerPage: <int>[10, 50, 100, 200],
                onRowsPerPageChanged: (rPP) {
                  if (rPP != null) {
                    setState(() {
                      rowsPerPage = rPP;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
