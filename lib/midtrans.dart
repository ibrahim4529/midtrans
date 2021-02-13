import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void MidtransTransactionFinishCallback(
    MidtransTransactionResult result);

extension ColorToHex on Color {
  String toHex() {
    return "#" + int.parse("${this.value}").toRadixString(16);
  }
}

class Midtrans {
  MidtransTransactionFinishCallback transactionFinishCallback;
  static Midtrans _instance = Midtrans._internal();
  static const MethodChannel _channel =
      const MethodChannel('com.liostech/midtrans');

  Midtrans._internal() {
    _channel.setMethodCallHandler(_channelHandler);
  }

  factory Midtrans() {
    return _instance;
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<void> init(MidtransConfig config) async {
    final argument = config.toJson();
    await _channel.invokeMethod("init", argument);
    return Future.value(null);
  }

  Future<void> payTransaction(MidtransTransaction transaction) async {
    final arguments = transaction.toJson();
    await _channel.invokeMethod("payTransaction", arguments);
    print("Done Canceled");
    return Future.value(null);
  }

  Future<void> payTransactionWithToken(
    String token,
  ) async {
    final arguments = {"token": token};
    await _channel.invokeMethod("payTransactionWithToken", arguments);
    return Future.value(null);
  }

  void setTransactionFinishCallback(
      MidtransTransactionFinishCallback callback) {
    transactionFinishCallback = callback;
  }

  Future _channelHandler(MethodCall call) async {
    if (call.method == "onTransactionFinished") {
      transactionFinishCallback(MidtransTransactionResult(
          transactionCanceled: call.arguments["transactionCanceled"],
          response: call.arguments["response"],
          source: call.arguments["source"],
          status: call.arguments["status"],
          statusMessage: call.arguments["statusMessage"]));
    }
  }
}

class MidtransConfig {
  final String clientKey;
  final String merchantBaseUrl;
  final String language;
  final MidtransColorTheme colorTheme;

  Map<String, dynamic> toJson() => {
        "client_key": clientKey,
        "merchant_base_url": merchantBaseUrl,
        "language": language,
        "color_theme": colorTheme.toJson()
      };

  MidtransConfig({
    @required this.clientKey,
    @required this.merchantBaseUrl,
    this.language = "id",
    this.colorTheme = const MidtransColorTheme(),
  });
}

class MidtransColorTheme {
  final Color lightPrimaryColor;
  final Color darkPrimaryColor;
  final Color secondaryColor;

  const MidtransColorTheme({
    this.lightPrimaryColor = const Color(0xFF999999),
    this.darkPrimaryColor = const Color(0xFF737373),
    this.secondaryColor = const Color(0xFFADADAD),
  });

  Map<String, dynamic> toJson() => {
        "light_primary_color": lightPrimaryColor.toHex(),
        "dark_primary_color": darkPrimaryColor.toHex(),
        "secondary_color": secondaryColor.toHex()
      };
}

class MidtransTransaction {
  final double amount;
  final bool skipCustomer;
  final MidtransCustomer midtransCustomer;
  final List<MidtransItem> items;

  MidtransTransaction({
    @required this.amount,
    @required this.skipCustomer,
    @required this.midtransCustomer,
    @required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "skip_customer": skipCustomer,
      "customer": midtransCustomer.toJson(),
      "items": items.map((item) => item.toJson()).toList(),
    };
  }
}

class MidtransItem {
  final String id;
  final double price;
  final int quantity;
  final String name;

  MidtransItem({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.name,
  });

  MidtransItem.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        price = json["price"],
        quantity = json["quantity"],
        name = json["name"];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "price": price,
      "quantity": quantity,
      "name": name,
    };
  }
}

class MidtransCustomer {
  final String customerIdentifier;
  final String phone;
  final String firstName;
  final String lastName;
  final MidtransCustomerAddress shippingAddress;
  final MidtransCustomerAddress billingAddress;
  final String email;

  MidtransCustomer({
    @required this.customerIdentifier,
    @required this.phone,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    this.shippingAddress,
    this.billingAddress,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = Map<String, dynamic>();
    result.addAll({
      "customer_identifier": customerIdentifier,
      "phone": phone,
      "first_name": firstName,
      "last_name": lastName,
      "email": email
    });
    if (billingAddress != null)
      result["billing_address"] = billingAddress.toJson();
    if (shippingAddress != null)
      result["shipping_address"] = shippingAddress.toJson();
    return result;
  }
}

class MidtransCustomerAddress {
  final String address;
  final String city;
  final String postalCode;

  MidtransCustomerAddress({
    @required this.address,
    @required this.city,
    @required this.postalCode,
  });

  Map<String, dynamic> toJson() =>
      {"address": address, "city": city, "postal_code": postalCode};
}

class MidtransTransactionResult {
  final String status;
  final String source;
  final String statusMessage;
  final String response;
  final bool transactionCanceled;

  MidtransTransactionResult({
    @required this.status,
    @required this.source,
    @required this.statusMessage,
    @required this.response,
    @required this.transactionCanceled,
  });
}
