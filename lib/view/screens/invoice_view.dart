import 'package:flutter/material.dart';
import '../../models/invoice.dart';
import '../widgets/company_detail.dart';
import '../widgets/customer_detail.dart';
import '../widgets/invoice_table.dart';

class InvoiceView extends StatelessWidget {
  const InvoiceView({super.key, required this.invoice});
  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice Book')),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          const Text(
            'Invoice',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color(0xff006966)),
          ),
          const SizedBox(
            height: 30,
          ),
          const CompanyDetail(),
          const SizedBox(
            height: 30,
          ),
          CustomerDetail(invoice: invoice),
          const SizedBox(
            height: 30,
          ),
          InvoiceTable(
            invoice: invoice,
          )
        ],
      )),
    );
  }
}
