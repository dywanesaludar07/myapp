import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/constants/bottombar.dart';
import 'package:hatidapp/constants/bottombar_riders.dart';
import 'package:hatidapp/constants/spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrderRider extends StatefulWidget {
  final orderId;
  OrderRider(this.orderId);
  OrderDetailsState createState() => OrderDetailsState(this.orderId);
}

class OrderDetailsState extends State<OrderRider> {
  final orderId;
  OrderDetailsState(this.orderId);
  List orders = [];
  Widget containerDetails = Container();
  String fragile = '0';
  @override
  void initState() {
    super.initState();
    containerDetails = Container(
        width: 30,
        height: 30,
        margin: EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(0),
        child: Spinkit());
    parcelDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff363636),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff363636),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade700, width: 3),
          borderRadius: BorderRadius.circular(35),
          color: Color(0xff2c2c2c),
          // boxShadow: [
          //   BoxShadow(color: Colors.green, spreadRadius: 3),
          // ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Banner(
                message: fragile == '0' ? "FRAGILE" : "NOT FRAGILE",
                location: BannerLocation.topEnd,
                color: Colors.red,
                child: containerDetails),
          ],
        ),
      ),
      bottomNavigationBar: BottomBarRiders(0),
    );
  }

  Widget detailWidget() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Order Details",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Verdana",
                  color: Color(0xffe9b603),
                  fontSize: 30),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
          decoration: BoxDecoration(
              color: Color(0xff2c2c2c) // set rounded corner radius
              ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xff363636),
              child: FaIcon(FontAwesomeIcons.sortNumericDown),
            ),
            title: Text(
              "Order # " +
                  Library().numHash(int.parse(orders[0]['id'])).toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
          decoration: BoxDecoration(
              color: Color(0xff2c2c2c) // set rounded corner radius
              ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xff363636),
              child: FaIcon(FontAwesomeIcons.boxOpen),
            ),
            title: Text(
              orders[0]['description'],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
          decoration: BoxDecoration(
              color: Color(0xff2c2c2c) // set rounded corner radius
              ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xff363636),
              child: FaIcon(FontAwesomeIcons.mapMarkerAlt),
            ),
            title: Text(
              orders[0]['pickup_location'] + " - " + orders[0]['drop_location'],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
          decoration: BoxDecoration(
              color: Color(0xff2c2c2c) // set rounded corner radius
              ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xff363636),
              child: FaIcon(FontAwesomeIcons.solidMoneyBillAlt),
            ),
            title: Text(
              num.parse(double.parse(orders[0]['total_fee']).toStringAsFixed(2))
                  .toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
          decoration: BoxDecoration(
              color: Color(0xff2c2c2c) // set rounded corner radius
              ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xff363636),
              child: FaIcon(FontAwesomeIcons.phone),
            ),
            title: Text(
              orders[0]['receiver_name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "+" + orders[0]['receiver_contact'],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
          decoration: BoxDecoration(
              color: Color(0xff2c2c2c) // set rounded corner radius
              ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xff363636),
              child: FaIcon(FontAwesomeIcons.calendar),
            ),
            title: Text(
              "Registered Date",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateFormat.yMMMd()
                  .format(DateTime.parse(orders[0]['create_date']))
                  .toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> parcelDetails() async {
    // Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "parcel_details.php";
    String sKey = Library().sKey;
    var postBody = {
      "parcel_details": nonce,
      'sKey': sKey,
      'parcelId': orderId.toString()
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        setState(() {
          orders = result;
          fragile = result[0]['product_quality'];
          containerDetails = detailWidget();
        });
        print(result);
      }
    } catch (ex) {
      print(ex.toString());
    }
  }
}
