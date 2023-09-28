import 'dart:async';
import 'package:provider/provider.dart';
import '../../logic/invoice_provoider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DateFilter extends StatefulWidget {
  const DateFilter({super.key});

  @override
  State<DateFilter> createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  DateTime? date1;
  DateTime? date2;

  void datePicker(bool flag) {
    showDatePicker(
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023, 8, 1),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        if (flag) {
          date1 = value;
        } else {
          date2 = value;
        }
      });
    });
  }

  void toast(String msg) {
    Fluttertoast.showToast(
        textColor: Colors.black,
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Color.fromRGBO(255, 197, 0, 100));
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
            child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () => datePicker(true),
                style: TextButton.styleFrom(foregroundColor: Color(0xff006966)),
                child: const Text(
                  'Start Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: date1 == null
                    ? const Text(
                        'No date selected',
                      )
                    : Text(DateFormat('dd/MM/yy').format(date1!))),
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () => datePicker(false),
                style: TextButton.styleFrom(foregroundColor: Color(0xff006966)),
                child: const Text(
                  'End Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: date2 == null
                    ? const Text(
                        'No date selected',
                      )
                    : Text(DateFormat('dd/MM/yy').format(date2!))),
          ],
        )),
        ListTile(
          title: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xff006966)),
              onPressed: date1 != null && date2 != null
                  ? () async {
                      if (date2!.isBefore(date1!)) {
                        toast('End date can\'t before start date');
                        return;
                      }
                      if (date1!.add(Duration(days: 14)).isBefore(date2!)) {
                        toast('Data can be fetched for up to 15 days');
                        return;
                      }

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

                        await Provider.of<InvoiceProvoider>(context,
                                listen: false)
                            .fetchDataBetweenDates(
                                DateFormat('yyyy-MM-dd').format(date1!),
                                DateFormat('yyyy-MM-dd').format(date2!));
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                        if (!Provider.of<InvoiceProvoider>(context,
                                listen: false)
                            .dataFound) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'No data is available for the selected date.')));
                        }
                      } catch (error) {
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title:
                                      const Text('Opps something went wrong'),
                                  content: Text(error.toString()),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xff006966)),
                                        child: const Text('Okay'))
                                  ],
                                ));
                      }
                    }
                  : null,
              child: const Text('Search')),
        ),
      ],
    );
  }
}
