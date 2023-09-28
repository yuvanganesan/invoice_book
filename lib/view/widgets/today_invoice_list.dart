import 'package:flutter/material.dart';
import '../../logic/invoice_provoider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TodayInvoiceList extends StatelessWidget {
  const TodayInvoiceList({super.key});

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: Colors.white),
      child: Text('Today'),
      onPressed: () async {
        try {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return WillPopScope(
                  onWillPop: _onWillPop,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ));
            },
          );

          await Provider.of<InvoiceProvoider>(context, listen: false)
              .fetchDataBetweenDates(
                  DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  DateFormat('yyyy-MM-dd').format(DateTime.now()));
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          if (!Provider.of<InvoiceProvoider>(context, listen: false)
              .dataFound) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('No data is available for the selected date.')));
          }
        } catch (error) {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Opps something went wrong'),
                    content: Text(error.toString()),
                    actions: [
                      ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff006966)),
                          child: const Text('Okay'))
                    ],
                  ));
        }
      },
    );
  }
}
