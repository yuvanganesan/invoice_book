import '../widgets/search_invoice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/invoice_list.dart';
import '../../logic/invoice_provoider.dart';
import '../widgets/date_filter.dart';
import '../widgets/today_invoice_list.dart';

class InvoiceListPage extends StatefulWidget {
  const InvoiceListPage({super.key});
  static const String routeName = '/invoice-list';

  @override
  State<InvoiceListPage> createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  late InvoiceProvoider emptyList;

  @override
  void dispose() {
    // TODO: implement dispose
    //Provider.of<InvoiceProvoider>(context, listen: false).emptyInvoiceList();
    emptyList.emptyInvoiceList();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    emptyList = Provider.of<InvoiceProvoider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice List'),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchInvoice());
              },
              icon: Icon(Icons.search)),
          TodayInvoiceList()
        ],
      ),
      body: Column(
        children: [
          DateFilter(),
          InvoiceList(),
        ],
      ),
    );
  }
}
