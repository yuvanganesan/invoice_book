import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:provider/provider.dart';
import '../../logic/invoice_provoider.dart';
import '../../models/invoice.dart';
import 'package:intl/intl.dart';
import '../widgets/increase_decrease_icon.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:animate_do/animate_do.dart';
// import 'package:background_sms/background_sms.dart' as bgsms;

// import 'package:telephony/telephony.dart';

class NewInvoice extends StatefulWidget {
  const NewInvoice({
    super.key,
  });
  static const String routeName = '/new-invoice';
  @override
  State<NewInvoice> createState() => _NewInvoiceState();
}

class _NewInvoiceState extends State<NewInvoice> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController selectedContact = TextEditingController();
  final _mobile = FocusNode();
  final List<FocusNode> _productName = [
    FocusNode(),
  ];
  final List<FocusNode> _productPrice = [
    FocusNode(),
  ];
  late String? customerName;
  late String mobile;
  late List<String> productName = [];
  late List<double> price = [];
  int count = 1;
  late Invoice invoice;

  void changeCount(bool flag, int index) {
    if (flag) {
      setState(() {
        count++;
        _productName.insert(index, FocusNode());
        _productPrice.insert(index, FocusNode());
      });
    } else {
      setState(() {
        count--;
        if (productName.length > index - 1 && price.length > index - 1) {
          productName.removeAt(index - 1);
          price.removeAt(index - 1);
        }
        _productName.removeAt(index - 1);
        _productPrice.removeAt(index - 1);
        //asMap().containsKey(index-1)
      });
    }
  }

  void modelBottomSheet() {
    showModalBottomSheet(
      isDismissible: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Send Invoice",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xff006966)),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                      onPressed: () {
                        _sendMessage('SMS');
                      },
                      icon: Image.asset('assets/images/sms.png', height: 24),
                      label: const Text('SMS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ))),
                  TextButton.icon(
                      onPressed: () {
                        _sendMessage('Whatsapp');
                      },
                      icon: Image.asset(
                        'assets/images/whatsapp.png',
                        height: 24,
                      ),
                      label: const Text('Whatsapp',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ))),
                ],
              ),
            ],
          ),
        );
      },
    ).then((_) {
      productName.clear();
      price.clear();
    });
  }

  bool invoiceValidateAndSave() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();
    if (mobile.length == 10) {
      mobile = '+91$mobile';
    }
    invoice = Invoice(
        customerName: customerName!,
        mobile: mobile,
        productName: productName,
        price: price,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    return true;
  }

  void _sendMessage(String source) async {
    try {
      if (source == 'SMS') {
        await Provider.of<InvoiceProvoider>(context, listen: false)
            .sendMessageThroughSms(invoice);
      } else {
        Provider.of<InvoiceProvoider>(context, listen: false)
            .sendMessageThroughWhatsapp(invoice);
      }
    } catch (error) {
      // ignore: avoid_print
      print(error.toString());
    }
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  void saveInvoice() async {
    if (!invoiceValidateAndSave()) {
      return;
    }

    //save invoice details in firebase
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
      await Provider.of<InvoiceProvoider>(context, listen: false)
          .saveInvoice(invoice);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Ivoice Saved", backgroundColor: const Color(0xff47d764));

      modelBottomSheet();
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Something went wrong..!'),
            content: Text(e.toString()),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff006966),
                      foregroundColor: Colors.white),
                  child: const Text('Okay'))
            ],
          );
        },
      );
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Invoice'), actions: [
          IconButton(
              onPressed: () {
                _formKey.currentState!.reset();
                selectedContact.clear();
              },
              icon: const Icon(Icons.refresh_outlined))
        ]),
        body: FadeIn(
          delay: const Duration(milliseconds: 300),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
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
                                        FocusScope.of(context)
                                            .requestFocus(_mobile),
                                    onSaved: (newValue) {
                                      if (newValue == null ||
                                          newValue.trim().length == 0) {
                                        customerName = 'Customer';
                                      } else {
                                        customerName = newValue;
                                      }
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
                                            onFieldSubmitted: (_) =>
                                                FocusScope.of(context)
                                                    .requestFocus(_productName
                                                        .elementAt(0)),
                                            validator: (value) {
                                              String patttern =
                                                  r'^\s*\+?\s*\d[\d\s-]+\d\s*$';

                                              RegExp regExp = RegExp(patttern);
                                              if (value!.isEmpty) {
                                                return "Please enter mobile number";
                                              }

                                              if (!regExp.hasMatch(value)) {
                                                return "Please enter valid mobile number";
                                              }
                                              return null;
                                            },
                                            onSaved: (newValue) {
                                              mobile =
                                                  newValue!.replaceAll(' ', '');
                                            }),
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
                                                selectedContact.text = contact
                                                    .phoneNumber!.number
                                                    .toString()
                                                    .replaceAll(' ', '');
                                              });
                                            } catch (e) {
                                              //no need to handle
                                            }
                                          },
                                          icon: Image.asset(
                                              'assets/images/contacts.png',
                                              height: 24),
                                          label: const Text(
                                            'Contacts',
                                            style: TextStyle(
                                                color: Color(0xff006966)),
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ...List.generate(count, (index) {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.name,
                                                decoration: const InputDecoration(
                                                    label: Text('Product Name'),
                                                    border:
                                                        OutlineInputBorder()),
                                                focusNode: _productName
                                                    .elementAt(index),
                                                onFieldSubmitted: (_) =>
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            _productPrice
                                                                .elementAt(
                                                                    index)),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Please enter product name";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (newValue) {
                                                  productName.insert(
                                                      index, newValue!);
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                  label: Text('Price'),
                                                  border: OutlineInputBorder(),
                                                ),
                                                focusNode: _productPrice
                                                    .elementAt(index),
                                                onFieldSubmitted: index + 1 !=
                                                        count
                                                    ? (_) => FocusScope.of(
                                                            context)
                                                        .requestFocus(
                                                            _productName
                                                                .elementAt(
                                                                    index + 1))
                                                    : null,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Please enter price";
                                                  }
                                                  if (double.tryParse(value) ==
                                                      null) {
                                                    return "Please enter valid price";
                                                  }
                                                  if (double.parse(value) <=
                                                      0) {
                                                    return "Please enter minimum price";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (newValue) {
                                                  price.insert(index,
                                                      double.parse(newValue!));
                                                },
                                              ),
                                            ),
                                            IncreaseDecrease(
                                              count: count,
                                              i: index + 1,
                                              changeCount: changeCount,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ))),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff006966)),
                    onPressed: () {
                      saveInvoice();
                    },
                    icon: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.save_rounded),
                    ),
                    label: const Text('Save',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
