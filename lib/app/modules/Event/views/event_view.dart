import 'package:flutter/material.dart';

class EventView extends StatelessWidget {
  const EventView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      columns: const [
        DataColumn(label: Text('Product')),
        DataColumn(label: Text('ItemID')),
        DataColumn(label: Text('Supplier')),
        DataColumn(label: Text('QTY')),
        DataColumn(label: Text('Customer')),
        DataColumn(label: Text('Address')),
        DataColumn(label: Text('Price')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('More')),
      ],
      source: MyDataTableSource(),
      rowsPerPage: 5,
      horizontalMargin: 0.0,
    );
  }
}

class MyDataTableSource extends DataTableSource {
  @override
  DataRow getRow(int index) {
    return const DataRow(cells: [
      DataCell(Text('1')),
      DataCell(SizedBox(
        width: double.infinity,
        child: Text('Led Strip Lights\nGovee -378695'),
      )),
      DataCell(Text('3')),
      DataCell(Text('05.11.21')),
      DataCell(Text('85\$')),
      DataCell(Text('30\$')),
      DataCell(Text('John Marks')),
      DataCell(Text('United States')),
      DataCell(Text('In Transit')),
    ]);
  }

  @override
  int get rowCount => 5;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
