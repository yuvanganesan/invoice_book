import 'package:flutter/material.dart';
import './view/screens/new_invoice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Billing',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal, accentColor: Colors.tealAccent)
          //ColorScheme.fromSeed(seedColor: Colors.teal),
          //useMaterial3: true,
          ),
      debugShowCheckedModeBanner: false,
      home: const NewInvoice(),
    );
  }
}
