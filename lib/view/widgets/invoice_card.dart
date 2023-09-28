import 'package:flutter/material.dart';
import '../../animation/fade_route.dart';
import '../screens/invoice_view.dart';
import '../../models/invoice.dart';
import 'package:provider/provider.dart';
import '../../logic/invoice_provoider.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({
    super.key,
    required this.invoice,
  });

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            FadeRoute(
                page: InvoiceView(
              invoice: invoice,
            )));
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: const Color(0xff006966),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: FittedBox(
                  child: Text(
                    invoice.date,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )),
          title: Text(invoice.customerName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(invoice.mobile),
              Text("(${invoice.invoiceId})"),
            ],
          ),
          //isThreeLine: true,
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () async {
                    await Provider.of<InvoiceProvoider>(context, listen: false)
                        .sendMessageThroughSms(invoice);
                  },
                  icon: Image.asset('assets/images/sms.png', height: 24)),
              IconButton(
                  onPressed: () {
                    Provider.of<InvoiceProvoider>(context, listen: false)
                        .sendMessageThroughWhatsapp(invoice);
                  },
                  icon: Image.asset('assets/images/whatsapp.png', height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
