import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PageReceipt extends StatefulWidget {
  final String url;
  final String orderId;
  PageReceipt(this.url, this.orderId);

  PageReceiptState createState() => PageReceiptState(this.url, this.orderId);
}

class PageReceiptState extends State<PageReceipt> {
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  String url;
  String orderId;
  String? userId;
  String? parcelId;
  PageReceiptState(this.url, this.orderId);

  @override
  void initState() {
    super.initState();
    setPref();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.times, color: Colors.white, size: 20),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Hero(
                tag: 'Payment',
                child: PhotoView(
                  filterQuality: FilterQuality.high,
                  enableRotation: false,
                  imageProvider: NetworkImage(url),
                ),
              ),
            ],
          )),
    );
  }

  setPref() async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    setState(() {
      userId = setSharedPreds.getString('riderId');
      parcelId = setSharedPreds.getString('parcelId');
    });
  }
}
