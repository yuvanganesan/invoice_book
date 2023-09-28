import '../../logic/invoice_provoider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  static const String routeName = '/settings';

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    int _languageChoosen =
        Provider.of<InvoiceProvoider>(context, listen: false).smsLanguageIndex;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('SMS Language',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
                Row(
                  children: [
                    Radio(
                      activeColor: const Color(0xff006966),
                      value: 0,
                      groupValue: _languageChoosen,
                      onChanged: (value) {
                        setState(() {
                          _languageChoosen = value!;
                        });
                        Provider.of<InvoiceProvoider>(context, listen: false)
                            .changeSmsLanguageIndex(value!);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'English',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      activeColor: const Color(0xff006966),
                      value: 1,
                      groupValue: _languageChoosen,
                      onChanged: (value) {
                        setState(() {
                          _languageChoosen = value!;
                        });
                        Provider.of<InvoiceProvoider>(context, listen: false)
                            .changeSmsLanguageIndex(value!);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Tamil',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
