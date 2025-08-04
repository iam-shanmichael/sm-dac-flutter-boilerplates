import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dac_data_table/dac_data_table.dart';

import 'test_helper.dart';

void main() {
  final source = TestSource();

  Widget testWidget() {
    return MaterialApp(
      home: Scaffold(
        body: DACDataTable(
          columns: [
            DACDataTableColumn(label: 'Id'),
          ],
          source: source,
        ),
      ),
    );
  }

  testWidgets('Ensure normal load', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Find the row
    expect(find.textContaining('5'), findsOneWidget);
    // Find the total rows avalible
    expect(find.textContaining('100'), findsOneWidget);
  });

  testWidgets('Ensure paging works', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Find the row
    expect(find.textContaining('5'), findsOneWidget);
    //Find the total rows avalible
    expect(find.textContaining('100'), findsOneWidget);

    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    expect(find.textContaining('15'), findsOneWidget);
  });

  testWidgets('Ensure rows per page works', (WidgetTester tester) async {
    int? rowsPerPage;

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => MaterialApp(
          home: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: DACDataTable(
                  source: TestSource(),
                  rowsPerPage: rowsPerPage ?? 10,
                  columns: [
                    DACDataTableColumn(label: 'Id'),
                  ],
                  paginatorSettings: DataTablePaginatorSettings(
                    availableRowsPerPage: [10, 20, 30, 45],
                    onRowsPerPageChanged: (r) {
                      setState(() {
                        rowsPerPage = r;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    // Find the row
    expect(find.text('8'), findsOneWidget);
    // Find the total rows avalible
    expect(find.textContaining('100'), findsOneWidget);
    //Find the rows per page dialog
    expect(find.byKey(const Key('rowsPerPage')), findsOneWidget);

    expect(
      (tester.widget(find.byKey(const Key('rowsPerPage'))) as DropdownButton)
          .value,
      10,
    );
    await tester.tap(find.byKey(const Key('rowsPerPage')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('45').last);
    await tester.pumpAndSettle();

    expect(rowsPerPage, 45);

    // 45 rows per page
    expect(find.text('44'), findsOneWidget);
  });

  testWidgets('Ensure column sort triggers', (WidgetTester tester) async {
    int? rowsPerPage;
    var sortIndex = 0;
    var sortAsc = true;

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => MaterialApp(
          home: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: DACDataTable(
                  source: TestSource(twoColumn: true),
                  columnToSort: sortIndex,
                  sortAscending: sortAsc,
                  rowsPerPage: rowsPerPage ?? 10,
                  paginatorSettings: DataTablePaginatorSettings(
                    availableRowsPerPage: [10, 20, 30, 45],
                    onRowsPerPageChanged: (r) {
                      setState(() {
                        rowsPerPage = r;
                      });
                    },
                  ),
                  columns: [
                    DACDataTableColumn(
                      label: 'Id',
                      onSort: (i, asc) {
                        setState(() {
                          sortIndex = i;
                          sortAsc = asc;
                        });
                      },
                    ),
                    DACDataTableColumn(
                      label: 'Value',
                      onSort: (i, asc) {
                        setState(() {
                          sortIndex = i;
                          sortAsc = asc;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Check if two columns are sortable
    expect(find.byIcon(Icons.arrow_upward), findsNWidgets(2));

    await tester.tap(find.text('Id'));
    await tester.pumpAndSettle();
    expect(sortAsc, false);
    expect(sortIndex, 0);

    await tester.tap(find.text('Value'));
    await tester.pumpAndSettle();
    expect(sortAsc, true);
    expect(sortIndex, 1);
  });

  testWidgets('Force remote reload', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    var lastLoad = source.lastLoad;
    // This should not change the last load time
    source.triggerListeners();
    await tester.pump();
    await tester.pumpAndSettle();
    expect(lastLoad, equals(source.lastLoad));

    // Now remote load should work
    source.forceReload();
    source.triggerListeners();
    await tester.pump();
    await tester.pumpAndSettle();
    expect(lastLoad, isNot(equals(source.lastLoad)));

    // Now it should be reseted and not change
    lastLoad = source.lastLoad;
    source.triggerListeners();
    await tester.pump();
    await tester.pumpAndSettle();
    expect(lastLoad, equals(source.lastLoad));
  });

  testWidgets('Force page index reload', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    final lastLoad = source.lastLoad;
    // This should not change the last load time
    source.triggerListeners();
    await tester.pump();
    await tester.pumpAndSettle();
    expect(lastLoad, equals(source.lastLoad));

    // Move to second page
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    expect(find.textContaining('15'), findsOneWidget);

    // Now remote load should work
    source.setNextView();
    await tester.pump();
    await tester.pumpAndSettle();
    expect(lastLoad, isNot(equals(source.lastLoad)));
    expect(source.nextStartIndex, isNull);
  });
}
