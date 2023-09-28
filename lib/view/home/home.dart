import 'package:flutter/material.dart';
import '../widgets/home_top.dart';
import '../screens/new_invoice.dart';
import '../screens/invoice_list_page.dart';
import '../../animation/fade_route.dart';
import 'package:provider/provider.dart';
import '../../logic/invoice_provoider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Widget menuCard(String title, String imgUrl) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      color: Colors.white.withOpacity(0.3),
      margin: const EdgeInsets.all(30),
      child: Padding(
          padding: const EdgeInsets.only(bottom: 30, top: 30, left: 20),
          child: ListTile(
              title: Text(title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              leading: Image.asset(
                imgUrl,
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<InvoiceProvoider>(context, listen: false).setSmsLanguageIndex();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Container(
          color: Theme.of(context).colorScheme.primary,
          height: height,
          width: width,
        ),
        Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              height: height * .4,
              width: width,
              child: HomeTop(
                width: width,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50))),
              height: height * .6,
              width: width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.of(context).pushNamed(NewInvoice.routeName);
                        Navigator.push(
                            context, FadeRoute(page: const NewInvoice()));
                      },
                      child: menuCard(
                        'New Invoice',
                        'assets/images/new_invoice.png',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context, FadeRoute(page: const InvoiceListPage()));
                        // Navigator.of(context,).pushNamed(InvoiceListPage.routeName);
                      },
                      child: menuCard(
                        'Invoice List',
                        'assets/images/invoice_list.png',
                      ),
                    )
                  ]),
            )
          ],
        ),
      ]),
    );
  }
}
