import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/views/view_riders/ongoin_parcel.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PageViewImage extends StatefulWidget {
  final String url;
  final String orderId;
  PageViewImage(this.url, this.orderId);

  PageViewState createState() => PageViewState(this.url, this.orderId);
}

class PageViewState extends State<PageViewImage> {
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  String url;
  String orderId;
  String? userId;
  String? parcelId;
  PageViewState(this.url, this.orderId);

  @override
  void initState() {
    super.initState();
    setPref();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: Color(0xff363636),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0xff363636),
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.times, color: Colors.white, size: 20),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          Container(
            width: 100,
            margin: EdgeInsets.all(5),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  fixedSize: Size.fromWidth(300),
                  backgroundColor: Color(0xffe9b603),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  showCupertinoDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                            title: Text("E-Hatid App"),
                            content:
                                Text("Are you sure this payment is correct?"),
                            actions: [
                              // Close the dialog
                              CupertinoButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                              CupertinoButton(
                                child: Text('Verify'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  acceptPayment();
                                },
                              )
                            ],
                          ));
                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text('Accept',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Verdana",
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                )),
          ),
        ],
        elevation: 0,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Hero(
            tag: 'Payment',
            child: PhotoView(
              filterQuality: FilterQuality.high,
              enableRotation: false,
              imageProvider: NetworkImage(url),
            ),
          )),
    );
  }

  Future<void> acceptPayment() async {
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "check_payment.php";
    String sKey = Library().sKey;
    var postBody = {
      'accept_payment': nonce,
      'sKey': sKey,
      'rider_id': userId.toString(),
      'parcelId': orderId.toString()
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      // Navigator.of(context).pop();
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print("ACCEPTEd");
        print(result);
        if (result[0] == "0") {
          Navigator.pop(context);
          Library().alertError(context,
              "Payment for this delivery is now settled. You can now start delivery");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OnGoingPage()));
        } else {
          Navigator.pop(context);
          Library().alertError(context,
              "There's a problem accepting the payment please try again later");
        }
      }
    } catch (ex) {
      print(ex.toString());
      Navigator.pop(context);
      Library().alertError(context, "Something wen't wrong");
    }
  }

  setPref() async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    setState(() {
      userId = setSharedPreds.getString('riderId');
      parcelId = setSharedPreds.getString('parcelId');
    });
  }
}
