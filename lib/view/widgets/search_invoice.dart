import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/invoice_provoider.dart';
import './dismiss_invoice.dart';

class SearchInvoice extends SearchDelegate {
  Future<void> searchAndFetch(BuildContext context) async {
    try {
      // print(query);
      // print(query.length);
      query.replaceAll(' ', '');
      if (query.length == 10) {
        query = '+91$query';
      }
      if (query.length > 0) {
        await Provider.of<InvoiceProvoider>(context, listen: false)
            .searchInvoiceByMobileNumber(query);
        // ignore: use_build_context_synchronously
        if (!Provider.of<InvoiceProvoider>(context, listen: false).dataFound) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('No data is available for the selected date.')));
        }
      }
    } catch (error) {
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
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    //close(context, null);

    return FutureBuilder(
      future: searchAndFetch(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final searchInvoice =
              Provider.of<InvoiceProvoider>(context, listen: false)
                  .getSearchInvoice;

          return ListView.builder(
            itemCount: searchInvoice.length,
            itemBuilder: (context, index) {
              return DismissInvoice(invoice: searchInvoice[index]);
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Container();
  }
}
