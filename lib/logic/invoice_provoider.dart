import 'dart:async';

import 'package:flutter/material.dart';
import '../models/invoice.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class InvoiceProvoider with ChangeNotifier {
  List<Invoice> _invoices = [];
  List<Invoice> _searchInvoices = [];
  int _smsLanguageIndex = 0;
  bool dataFound = false;

  void setSmsLanguageIndex() async {
    final pref = await SharedPreferences.getInstance();
    //if it present in sharedpreference else 0
    _smsLanguageIndex = pref.getInt('LanguageIndex') ?? 0;
  }

  void changeSmsLanguageIndex(int index) async {
    _smsLanguageIndex = index;
    final pref = await SharedPreferences.getInstance();

    pref.setInt('LanguageIndex', index);
  }

  int get smsLanguageIndex {
    return _smsLanguageIndex;
  }

  List<Invoice> get getInvoice {
    return [..._invoices];
  }

  List<Invoice> get getSearchInvoice {
    return [..._searchInvoices];
  }

  void emptyInvoiceList() {
    _invoices.clear();
    //_invoices = [];
  }

  String textMessage(Invoice invoice) {
    double total = 0;
    for (var element in invoice.price) {
      total += element;
    }

    List<String> messages = [
      """Dear ${invoice.customerName},

Thank you so much for choosing Zam Zam Mobiles! We appreciate your recent purchase of ${invoice.productName} ₹$total on ${invoice.date}. Your invoice id is ${invoice.invoiceId}. If you have any questions or need assistance, please don't hesitate to reach out to us at Zam Zam Mobiles Mukkuchalai-Peraiyur, +91 63839 32022.

Warm regards,
Zam Zam Mobiles.""",
      """அன்புள்ள ${invoice.customerName},

ஜம் ஜம் மொபைல்சை தேர்ந்தெடுத்ததற்கு மிக்க நன்றி! ${invoice.date} அன்று நீங்கள் ${invoice.productName} ₹$total சமீபத்தில் வாங்கியதை நாங்கள் பாராட்டுகிறோம். உங்கள் பில் ஐடி ${invoice.invoiceId} ஆகும். உங்களிடம் ஏதேனும் கேள்விகள் இருந்தால் அல்லது உதவி தேவைப்பட்டால், ஜம் ஜம் மொபைல்ஸ் முக்குச்சாலை-பேரையூர், +91 63839 32022 இல் எங்களைத் தொடர்புகொள்ள தயங்க வேண்டாம்.

அன்பான வாழ்த்துக்கள்,
ஜம் ஜம் மொபைல்ஸ்"""
    ];

    return messages[_smsLanguageIndex];
  }

  Future<void> sendMessageThroughSms(Invoice invoice) async {
    final String message = textMessage(invoice);
    try {
      await sendSMS(
        message: message,
        recipients: [invoice.mobile],
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void sendMessageThroughWhatsapp(Invoice invoice) {
    final String message = textMessage(invoice);
    //'https://wa.me/$mobile?text=hello this works..!',mode: LaunchMode.externalNonBrowserApplication
    final uri = 'whatsapp://send?phone=${invoice.mobile}&text=$message';
    try {
      launchUrl(
        Uri.parse(uri),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveInvoice(Invoice invoice) async {
    try {
      // Create a reference to the Realtime Database
      final DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref("invoices");

// Define the data you want to insert
      Map<String, dynamic> data = {
        'customerName': invoice.customerName,
        'mobile': invoice.mobile,
        'date': invoice.date,
        'products': List.generate(invoice.productName.length, (index) {
          return {
            'productName': invoice.productName[index],
            'price': invoice.price[index].toString(),
            'quantity': '1'
          };
        }),
      };
// Creating uniqueId

      DateTime currentDateTime = DateTime.now();

      // Extract year, month, day, hour, minute, and second components
      String year = currentDateTime.year.toString().substring(2);
      String month = currentDateTime.month.toString().padLeft(2, '0');
      String day = currentDateTime.day.toString().padLeft(2, '0');
      String hour = currentDateTime.hour.toString().padLeft(2, '0');
      String minute = currentDateTime.minute.toString().padLeft(2, '0');
      String second = currentDateTime.second.toString().padLeft(2, '0');

      // Generate the unique ID
      String uniqueId = "$day$month$year$hour$minute$second";

// Insert data into a specific node in the database
      final DatabaseReference newInvoiceReference =
          databaseReference.child(uniqueId);
      await newInvoiceReference.set(data);

      invoice.invoiceId = newInvoiceReference.key;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchDataBetweenDates(String startDate, String endDate) async {
    dataFound = false;
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    try {
      final snapshot = await databaseReference
          .child("invoices")
          .orderByChild("date")
          .startAt(startDate)
          .endAt(endDate)
          .get();

      if (snapshot.exists) {
        dataFound = true;
        final Map<dynamic, dynamic> loadedData =
            snapshot.value as Map<dynamic, dynamic>;
        List<Invoice> tempInvoices = [];
        loadedData.forEach((key, value) {
          //Map<String, Object> value = _value as Map<String, Object>;
          tempInvoices.add(Invoice(
            invoiceId: key.toString(),
            customerName: value['customerName'].toString(),
            mobile: value['mobile'].toString(),
            productName: (value['products'] as List<dynamic>)
                .map((e) => e['productName'].toString())
                .toList(),
            price: (value['products'] as List<dynamic>)
                .map((e) => double.parse(e['price'].toString()))
                .toList(),
            date: DateFormat('dd.MM.yy').format(
                DateFormat('yyyy-MM-dd').parse(value['date'].toString())),
          ));
        });
        _invoices = tempInvoices;
        notifyListeners();
      }
    } catch (error) {
      dataFound = true;
      rethrow;
      // print('Error fetching data: $error');
    }
  }

  Future<void> searchInvoiceByMobileNumber(String mobileNumber) async {
    dataFound = false;

    _searchInvoices.clear();
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    try {
      // Create a query to search for users with a specific mobile number
      Query query = databaseReference
          .child('invoices')
          .orderByChild('mobile')
          .equalTo(mobileNumber);

      DataSnapshot snapshot = await query.get();

      if (snapshot.exists) {
        dataFound = true;
        final Map<dynamic, dynamic> loadedData =
            snapshot.value as Map<dynamic, dynamic>;
        List<Invoice> tempInvoices = [];
        loadedData.forEach((key, value) {
          //Map<String, Object> value = _value as Map<String, Object>;
          tempInvoices.add(Invoice(
            invoiceId: key.toString(),
            customerName: value['customerName'].toString(),
            mobile: value['mobile'].toString(),
            productName: (value['products'] as List<dynamic>)
                .map((e) => e['productName'].toString())
                .toList(),
            price: (value['products'] as List<dynamic>)
                .map((e) => double.parse(e['price'].toString()))
                .toList(),
            date: DateFormat('dd.MM.yy').format(
                DateFormat('yyyy-MM-dd').parse(value['date'].toString())),
          ));
        });
        _searchInvoices = tempInvoices;
        //notifyListeners();
      }
    } catch (e) {
      dataFound = true;
      print(e.toString());
      rethrow;
    }
  }

  void deleteNode(String nodePath) {
    final DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('invoices');
    databaseReference.child(nodePath).remove().then((_) {
      print("Node deleted successfully.");
    }).catchError((error) {
      throw error;
      //print("Failed to delete node: $error");
    });
  }
}

//  Future<void> fetchData() async {
//     final DatabaseReference databaseReference =
//         FirebaseDatabase.instance.ref().child('invoices');

//     try {
//       final snapshot = await databaseReference.get();
//       if (snapshot.exists) {
//         final Map<dynamic, dynamic> loadedData =
//             snapshot.value as Map<dynamic, dynamic>;
//         List<Invoice> tempInvoices = [];
//         loadedData.forEach((key, value) {
//           //Map<String, Object> value = _value as Map<String, Object>;
//           tempInvoices.add(Invoice(
//             invoiceId: key.toString(),
//             customerName: value['customerName'].toString(),
//             mobile: value['mobile'].toString(),
//             productName: (value['products'] as List<dynamic>)
//                 .map((e) => e['productName'].toString())
//                 .toList(),
//             price: (value['products'] as List<dynamic>)
//                 .map((e) => double.parse(e['price'].toString()))
//                 .toList(),
//             date: DateFormat('dd.MM.yy').format(
//                 DateFormat('yyyy-MM-dd').parse(value['date'].toString())),
//           ));
//         });
//         _invoices = tempInvoices;
//         notifyListeners();
//       }
//     } catch (error) {
//       print('Error fetching data: $error');
//     }
//   }