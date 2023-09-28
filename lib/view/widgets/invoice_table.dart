import 'package:flutter/material.dart';
import '../../models/invoice.dart';

class InvoiceTable extends StatelessWidget {
  const InvoiceTable({super.key, required this.invoice});
  final Invoice invoice;

  TableRow buildHeader(List<String> cells) {
    return TableRow(
        children: cells.map((cell) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          cell,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      );
    }).toList());
  }

  TableRow buildRows(List<String> cells) {
    return TableRow(
        children: cells.map((cell) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          cell,
          // textAlign: TextAlign.center,
          // style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      );
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    double total = 0;
    for (var element in invoice.price) {
      total += element;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Table(
        border: TableBorder.all(),
        columnWidths: const {
          0: FractionColumnWidth(0.4),
          1: FractionColumnWidth(0.2),
          2: FractionColumnWidth(0.2),
          3: FractionColumnWidth(0.2)
        },
        children: [
          buildHeader(['Product Name', 'Quantity', 'Rate', 'Amount']),
          ...List.generate(invoice.productName.length, (index) {
            return buildRows([
              invoice.productName[index],
              '1',
              invoice.price[index].toString(),
              invoice.price[index].toString()
            ]);
          }),
          TableRow(children: [
            const Text(''),
            const Text(''),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Total',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(total.toString()),
            )
          ])
        ],
      ),
    );
  }
}
