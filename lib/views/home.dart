import 'dart:convert';
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/constants/bottombar.dart';
import 'package:hatidapp/views/about_us.dart';
import 'package:hatidapp/views/login.dart';
import 'package:hatidapp/views/notifications.dart';
import 'package:hatidapp/views/view_riders/profile_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as Math;

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  String? userId;
  List details = [];
  Widget containerDetails = Container();
  Widget profileContainer = Container();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    containerDetails = SpinKitChasingDots(
      color: Colors.white,
      size: 20.0,
    );
  }

  @override
  void initState() {
    super.initState();
    setPref();
  }

  Widget setProfile() {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileViewer(Library().url +
                      "dp_sender.php/?width=900&url=" +
                      Library().numHash(int.parse(userId!)).toString())));
        },
        child: Container(
          width: 110.0,
          height: 110.0,
          decoration: BoxDecoration(
            color: Colors.grey,
            image: DecorationImage(
              image: NetworkImage(Library().url +
                  "dp_sender.php/?width=900&url=" +
                  Library().numHash(int.parse(userId!)).toString()),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
            border: Border.all(
              color: Color(0xff363636),
              width: 3.0,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff363636),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xffe9b603),
          automaticallyImplyLeading: false,
          // actions: [
          //   Container(
          //       margin: EdgeInsets.all(10),
          //       child: TextButton(
          //           style: TextButton.styleFrom(
          //               backgroundColor: Color(0xff363636),
          //               fixedSize: Size.fromHeight(20)),
          //           onPressed: () {},
          //           child: Text('Edit',
          //               style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                   color: Color(0xffe9b603))))),
          // ]),
        ),
        body: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Color(0xffe9b603),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35.0),
                      bottomRight: Radius.circular(35.0)),
                ),
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    SizedBox(width: 5),
                    profileContainer,
                    SizedBox(width: 5),
                    containerDetails,
                  ],
                )),
            SizedBox(height: 50),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size.fromWidth(300),
                    backgroundColor: Color(0xff2c2c2c),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    side: BorderSide(width: 1, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPage()));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Notification',
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: "Verdana",
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                  )),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size.fromWidth(300),
                    backgroundColor: Color(0xff2c2c2c),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    side: BorderSide(width: 1, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AboutPage()));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('About Us',
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: "Verdana",
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                  )),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size.fromWidth(300),
                    backgroundColor: Color(0xff2c2c2c),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    side: BorderSide(width: 1, color: Colors.white),
                  ),
                  onPressed: () {
                    showAlertDialog(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Logout',
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: "Verdana",
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                  )),
            ),
          ],
        ),
        bottomNavigationBar: BottomBar(3));
  }

  Widget detailsWidget() {
    return Container(
        margin: EdgeInsets.only(
          top: 80,
          left: 10,
        ),
        child: Column(
          children: [
            SizedBox(
              width: 200,
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        details[0]['account_name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 30),
                      ))),
            ),
            SizedBox(
              width: 200,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  details[0]['email_address'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15),
                ),
              ),
            ),
          ],
        ));
  }

  void showAlertDialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("E-Hatid App"),
              content: Text("Do you really want to log out this account?"),
              actions: [
                // Close the dialog
                CupertinoButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                CupertinoButton(
                  child: Text('Yes'),
                  onPressed: () {
                    removePref();
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false);
                  },
                )
              ],
            ));
  }

  Future<void> getUserDetails() async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "user_details.php";
    String sKey = Library().sKey;

    var postBody = {
      "get_details": nonce,
      'sKey': sKey,
      'userId': userId.toString(),
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] != '0') {
          setState(() {
            details = result;
            containerDetails = detailsWidget();
            evictImage(Library().url +
                "dp_sender.php/?width=900&url=" +
                Library().numHash(int.parse(userId!)).toString());
          });
        } else {
          Library().alertError(context, "Something wen't wrong");
        }
      }
    } catch (ex) {
      print(ex.toString());
      Library().alertError(context, "Something wen't wrong");
    }
  }

  void evictImage(url) {
    final NetworkImage provider = NetworkImage(url);
    provider.evict().then<void>((bool success) {
      if (success) debugPrint('removed image!');
    });
  }

  removePref() async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    setState(() {
      setSharedPreds.remove('userId');
    });
  }

  setPref() async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    setState(() {
      userId = setSharedPreds.getString('userId');
      profileContainer = setProfile();
    });
    getUserDetails();
  }
}
