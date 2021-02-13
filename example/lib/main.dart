import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:midtrans/midtrans.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final midtrans = Midtrans();
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    midtrans.init(MidtransConfig(
      clientKey: 'YOUR CLIENT_KEY',
      merchantBaseUrl: 'https://YOUR_MERCHANT_URL_DOMAIN.com/',
      colorTheme: MidtransColorTheme(
        lightPrimaryColor: Colors.deepOrange,
        darkPrimaryColor: Colors.deepOrange,
        secondaryColor: Colors.blueAccent
      )
    ));
    midtrans.setTransactionFinishCallback((result) {
      print("Result ${result.status}");
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await midtrans.payTransaction(MidtransTransaction(
              amount: 40000,
              skipCustomer: false,
              midtransCustomer: MidtransCustomer(
                  customerIdentifier: "USER01",
                  phone: "089689008988",
                  lastName: "Hanif",
                  firstName: "Ibrahim",
                  email: 'email@mail.com',
                billingAddress: MidtransCustomerAddress(
                  address: "Losari Kidul",
                  city: "Cirebon",
                  postalCode: "45192"
                )
              ),
              items: [
                MidtransItem("id-10", 20000, 2, "Makanan"),
              ],
            ));
          },
        ),
      ),
    );
  }
}
