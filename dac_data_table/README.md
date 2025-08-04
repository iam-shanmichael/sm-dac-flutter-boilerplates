# PDAX Data Table

- Version: 1.0.0
- Supported platforms: Android, iOS, & Web
- Packages dependent on:
    
    - [advance_datatable](https://pub.dev/packages/advanced_datatable)

A widget that uses Flutter [PaginatedDataTable](https://api.flutter.dev/flutter/material/PaginatedDataTable-class.html) widget and allowing pagination for server side responses.

## Features
- Can add and customize your desired columns and rows based on the response received from your API.
- Customize loading and error widgets.
- Can add custom paginator or footer.


## Installation via Github repo
Once you clone this on your local computer, add the local path of this package on the `pubspec.yaml` file of your desired project .

```yaml
  pdax_data_table: 
    path: <PATH_ON_YOUR_LOCAL>
```

## Create data source
You must create a data source. This will be responsible for fetching and plotting all of your data to the data table.

```dart
    // Employee model
    class Employee {
        Employee(
            this.id,
            this.name,
            this.designation,
            this.salary,
        );

        final int id;
        final String name;
        final String designation;
        final int salary;
    }

    class EmployeeDataSource extends AdvancedDataTableSource<Employee> {
        //...
    }
```

You also need to implement the getNextPage function, this function is always called when the view wants to render a new page. You will get the following details:

- pageSize as int
- offset as int

```dart
    class EmployeeDataSource extends AdvancedDataTableSource<Employee>{
        // Mockup for requesting data from some external source
        Future<RemoteDataSourceDetails<Employee>> getNextPage(NextPageRequest pageRequest) async {
            await Future.delayed(Duration(seconds: 5));
            return RemoteDataSourceDetails(
                data.length,
                data.skip(pageRequest.offset).take(pageRequest.pageSize).toList(),
            );
        }
    }
```

While the getNextPage function is running the table shows a loading Widget (see below).

## Custom loading and error widget
You can set a custom loading and error widget by using the following props:

- loadingWidget
- errorWidget

The above props are functions that will be run when the widget is needed and have to return a single widget.

## Server side filter

To show the user that a filter is live you should return from your data backend always two numbers:

- total number of rows without any filter
- total number of rows with the current active filter (or null if no filter is set, the default)

This can be done by setting filteredRows to a none null value. If filteredRows is set, advanced_datatable will treat
this as the new total rows but still shows the user the amount of unfiltered rows. If you want to define how this is shown check the [Custom row number label](#custom-row-number-label)
To ensure that in case a filter was applied to the data your table starts on page 1 again, call `setNextView();` function inside your AdvancedDataTableSource (it will trigger the reload for you):

```dart
class ExampleSource extends AdvancedDataTableSource<RowData> {

    //...

  void filterServerSide(String filterQuery) {
    lastSearchTerm = filterQuery.toLowerCase().trim();
    setNextView();
  }
    
    //...
}
```

## Custom row number label
You can override the paginator row label to include custom text, this makes sense in case you have server side filter
and want to include another local or structure in the label:

```dart
   paginatorSettings: DataTablePaginatorSettings(
        getPaginatorRowText: (startRow, pageSize, totalFilter, totalRowsWithoutFilter) {
            final localizations = MaterialLocalizations.of(context);

            var amountText = localizations.pageRowsInfoTitle(
              startRow,
              pageSize,
              totalFilter ?? totalRowsWithoutFilter,
              false,
            );
            
            if (totalFilter != null) {
              // Filtered data source show addtional information
              amountText += ' filtered from ($totalFilter)';
            }

            return amountText;
        },
   ),
```

## Example
You can find a simple example in the `/example` folder, below is the code of the main.dart file:

```dart
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
      title: 'PDAX Data Table Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'PDAX Data Table Home Page'),
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
```

## Example Data Source

```dart
import 'package:example/models/employee.dart';
import 'package:pdax_data_table/pdax_data_table.dart';

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
        PDAXDataTableCell(
          PDAXDataTableCellText(currentRowData.id.toString()),
        ),
        PDAXDataTableCell(
          PDAXDataTableCellText(currentRowData.name.toString()),
        ),
        PDAXDataTableCell(
          PDAXDataTableCellText(currentRowData.designation.toString()),
        ),
        PDAXDataTableCell(
          PDAXDataTableCellText(currentRowData.salary.toString()),
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
```

## Issues
- [advance_datatable](https://pub.dev/packages/advanced_datatable) has still a known issue regarding horizontal scrolling in flutter web. 

    - See https://github.com/Dev-Owl/advanced_datatable/issues/19 for your reference. As a workaround on your MaterialApp, add a `scrollBehavior` with targeted drag devices such as `mouse and trackpad`. See the example below:

    ```dart
        class MyApp extends StatelessWidget {
            const MyApp({Key? key}) : super(key: key);

            @override
            Widget build(BuildContext context) {
                return MaterialApp(
                    title: 'PDAX Data Table Demo',
                    theme: ThemeData(primarySwatch: Colors.blue),
                    home: const MyHomePage(title: 'PDAX Data Table Home Page'),
                    scrollBehavior: const MaterialScrollBehavior().copyWith(
                        dragDevices: {
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.trackpad,
                        },
                    ),
                );
            }
        }   
    ```






