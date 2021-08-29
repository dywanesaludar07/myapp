import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:http/http.dart' as http;

void main() => runApp(
      MaterialApp(
        home: BraintRee(),
      ),
    );

class BraintRee extends StatefulWidget {
  @override
  BraintReeState createState() => BraintReeState();
}

class BraintReeState extends State<BraintRee> {
  static final String tokenizationKey = 'sandbox_38k3g4rx_x8w6jtn4jjcn6cqv';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Braintree example app'),
        ),
        body: Center(
            child: ElevatedButton(
          onPressed: () async {
            final request = BraintreeDropInRequest(
              tokenizationKey: tokenizationKey,
              collectDeviceData: true,
              googlePaymentRequest: BraintreeGooglePaymentRequest(
                totalPrice: '1.00',
                currencyCode: 'PHP',
                billingAddressRequired: false,
              ),
              paypalRequest: BraintreePayPalRequest(
                amount: '1.00',
                displayName: 'E-Hatid Application',
              ),
            );
            BraintreeDropInResult res = await BraintreeDropIn.start(request);

            if (res != null) {
              try {
                const pageId = 'paypal.php';
                String url = Library().url + "/" + pageId;
                var postBody = {
                  'nonce': res.paymentMethodNonce.nonce,
                  'device': res.deviceData,
                };
                http.Response response =
                    await Library().postRequest(url, postBody);

                if (response.statusCode == 200) {
                  var result = jsonDecode(response.body);
                  print(result);
                }
              } catch (ex) {
                print(ex.toString());
              }
            }
          },
          child: Text("Pay"),
        )));
  }
}
