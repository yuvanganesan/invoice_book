import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/invoice_provoider.dart';
import './dismiss_invoice.dart';

class InvoiceList extends StatelessWidget {
  const InvoiceList({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Consumer<InvoiceProvoider>(
      builder: (context, value, child) {
        final invoice = value.getInvoice;
        return invoice.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: invoice.length,
                  itemBuilder: (context, index) {
                    return DismissInvoice(
                      invoice: invoice[index],
                    );
                  },
                ),
              )
            : Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/noData.png',
                        height: deviceWidth * .7,
                        width: deviceWidth * .7,
                      ),
                      Text(
                        'Select two dates and click search',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
