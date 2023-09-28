import 'package:flutter/material.dart';
import './invoice_card.dart';
import 'package:provider/provider.dart';
import '../../logic/invoice_provoider.dart';
import '../../models/invoice.dart';

class DismissInvoice extends StatelessWidget {
  const DismissInvoice({
    super.key,
    required this.invoice,
  });
  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        try {
          Provider.of<InvoiceProvoider>(context, listen: false)
              .deleteNode(invoice.invoiceId!);
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      },
      background: Container(
        padding: const EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        color: Theme.of(context).colorScheme.error,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      key: ValueKey(invoice.invoiceId),
      confirmDismiss: (_) {
        return showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text("Are you sure?"),
                content: const Text("Do yoy want to delete this invoice?"),
                actions: [
                  TextButton(
                      onPressed: (() {
                        return Navigator.of(context).pop(false);
                      }),
                      child: const Text("No")),
                  TextButton(
                      onPressed: (() {
                        return Navigator.of(context).pop(true);
                      }),
                      child: const Text("Yes"))
                ],
              );
            });
      },
      child: InvoiceCard(invoice: invoice),
    );
  }
}
