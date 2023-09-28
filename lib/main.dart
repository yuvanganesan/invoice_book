import 'package:flutter/material.dart';
import './view/screens/new_invoice.dart';
import 'view/screens/invoice_list_page.dart';
import './view/screens/settings.dart';
import 'package:provider/provider.dart';
import './logic/invoice_provoider.dart';
import 'package:firebase_core/firebase_core.dart';
import './firebase_options.dart';
import './view/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: InvoiceProvoider(),
      child: MaterialApp(
        title: 'Billing',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.teal, accentColor: Colors.tealAccent)
            //ColorScheme.fromSeed(seedColor: Colors.teal),
            //useMaterial3: true,
            ),
        debugShowCheckedModeBanner: false,
        home: const Home(),
        routes: {
          NewInvoice.routeName: (context) => const NewInvoice(),
          InvoiceListPage.routeName: (context) => const InvoiceListPage(),
          Settings.routeName: (context) => const Settings()
        },
      ),
    );
  }
}
