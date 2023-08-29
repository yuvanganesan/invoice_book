import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:telephony/telephony.dart';

class NewInvoice extends StatefulWidget {
  const NewInvoice({
    super.key,
  });

  @override
  State<NewInvoice> createState() => _NewInvoiceState();
}

class _NewInvoiceState extends State<NewInvoice> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController selectedContact = TextEditingController();
  final _mobile = FocusNode();
  final _productName = FocusNode();
  final _productPrice = FocusNode();

  void _sendMessage(String source) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    try {
      if (source == 'SMS') {
        final telephony = Telephony.instance;
        final bool? result = await telephony.requestPhoneAndSmsPermissions;

        if (result != null && result) {
          await telephony.sendSms(
            to: selectedContact.text,
            message: "hello this works..!",
            statusListener: (status) {
              if (status == SendStatus.SENT) {
                Fluttertoast.showToast(
                    msg: "SMS Send", backgroundColor: const Color(0xffffc021));
              } else {
                if (status == SendStatus.DELIVERED) {
                  Fluttertoast.showToast(
                      msg: "SMS Delevered",
                      backgroundColor: const Color(0xff47d764));
                } else {
                  Fluttertoast.showToast(
                      msg: "SMS Not Send",
                      backgroundColor: const Color(0xffff355b));
                }
              }
            },
          );
        }

        // final result = await bgsms.BackgroundSms.sendMessage(
        //     phoneNumber: selectedContact.text, message: "hello this works..!");
        // if (result == bgsms.SmsStatus.sent) {
        //   Fluttertoast.showToast(
        //       msg: "Message send", backgroundColor: const Color(0xff47d764));
        // } else {
        //   Fluttertoast.showToast(
        //       msg: "Message not send",
        //       backgroundColor: const Color(0xffff355b));
        // }
      } else {
        //'https://wa.me/${selectedContact.text}?text=hello this works..!',mode: LaunchMode.externalNonBrowserApplication
        final uri =
            'whatsapp://send?phone=${selectedContact.text}&text=hello this works..!';
        launchUrl(
          Uri.parse(uri),
        );
      }
    } catch (error) {
      // ignore: avoid_print
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice'), actions: [
        IconButton(
            onPressed: () {
              _formKey.currentState!.reset();
              selectedContact.clear();
            },
            icon: const Icon(Icons.refresh_outlined))
      ]),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            'New Invoice',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color(0xff006966)),
          ),
          Padding(
              padding: const EdgeInsets.all(
                20,
              ),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                            label: Text('Customer Name'),
                            border: OutlineInputBorder()),
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_mobile),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter customer name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: selectedContact,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  label: Text('Mobile'),
                                  border: OutlineInputBorder()),
                              focusNode: _mobile,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_productName),
                              validator: (value) {
                                String patttern = r'^\s*\+?\s*\d[\d\s-]+\d\s*$';
                                // r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                RegExp regExp = RegExp(patttern);
                                if (value!.isEmpty) {
                                  return "Please enter mobile number";
                                }

                                if (!regExp.hasMatch(value)) {
                                  //value == null ||
                                  return "Please enter valid mobile number";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton.icon(
                              onPressed: () async {
                                try {
                                  final PhoneContact contact =
                                      await FlutterContactPicker
                                          .pickPhoneContact();
                                  setState(() {
                                    selectedContact.text =
                                        contact.phoneNumber!.number.toString();
                                  });
                                } catch (e) {
                                  //no need to handle
                                }
                              },
                              icon: Image.asset('assets/images/contacts.png',
                                  height: 24),
                              label: const Text('Contacts')),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                  label: Text('Product Name'),
                                  border: OutlineInputBorder()),
                              focusNode: _productName,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_productPrice),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter product name";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  label: Text('Price'),
                                  border: OutlineInputBorder()),
                              focusNode: _productPrice,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter price";
                                }
                                if (double.tryParse(value) == null) {
                                  return "Please enter valid price";
                                }
                                if (double.parse(value) <= 0) {
                                  return "Please enter minimum price";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                  onPressed: () {
                    _sendMessage('SMS');
                  },
                  icon: Image.asset('assets/images/sms.png', height: 24),
                  label: const Text('SMS')),
              TextButton.icon(
                  onPressed: () {
                    _sendMessage('Whatsapp');
                  },
                  icon: Image.asset(
                    'assets/images/whatsapp.png',
                    height: 24,
                  ),
                  label: const Text('Whatsapp'))
            ],
          )
        ],
      ),
    );
  }
}
