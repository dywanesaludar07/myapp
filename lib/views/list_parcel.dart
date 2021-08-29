import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/constants/bottombar.dart';
import 'package:hatidapp/constants/spinkit.dart';
import 'package:hatidapp/views/order_details.dart';
import 'package:hatidapp/views/track_parcel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ListParcelPage extends StatefulWidget {
  ListParcelPageState createState() => ListParcelPageState();
}

class ListParcelPageState extends State<ListParcelPage> {
  List results = [];
  List pendingResults = [];
  List unverifiedResults = [];
  Widget content1 = Container();
  Widget content2 = Container();
  Widget content3 = Container();
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  String? userId = '';
  String? email = '';
  String orderId = '';
  TextEditingController otpController = new TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    content1 = SpinKitRotatingCircle(
      color: Colors.white,
      size: 50.0,
    );
  }

  @override
  void initState() {
    super.initState();
    setPref();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xff363636),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "List of Parcels",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          backgroundColor: Color(0xffe9b603),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.directions_bike, color: Color(0xff363636)),
                child: Text(
                  "To Receive/Deliver",
                  textAlign: TextAlign.center,
                ),
              ),
              Tab(
                icon: Icon(Icons.verified_outlined, color: Color(0xff363636)),
                child: Text(
                  "For Verification",
                  textAlign: TextAlign.center,
                ),
              ),
              Tab(
                icon: Icon(Icons.pending_actions_outlined,
                    color: Color(0xff363636)),
                child: Text(
                  "Pending Parcel",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [content1, content3, content2],
        ),
        bottomNavigationBar: BottomBar(1),
      ),
    );
  }

  void showAlertDialog(BuildContext context, id) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("E-Hatid App"),
              content: Text("Do you really want to cancel this request?"),
              actions: [
                // Close the dialog
                CupertinoButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                CupertinoButton(
                  child: Text('Yes'),
                  onPressed: () {
                    cancelPendingRequest(id);
                  },
                )
              ],
            ));
  }

  Widget listPendingParcel() {
    return Container(
        height: MediaQuery.of(context).size.height - 100,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: pendingResults.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetails(pendingResults[index]['id'])));
                    },
                    title: Text(
                        "Order #" +
                            Library()
                                .numHash(int.parse(pendingResults[index]['id']))
                                .toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    subtitle: Text(pendingResults[index]['description'],
                        style: TextStyle(color: Colors.grey)),
                    trailing: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size.fromWidth(100),
                          backgroundColor: Color(0xffe9b603),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        onPressed: () {
                          showAlertDialog(context, pendingResults[index]['id']);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('Cancel',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Verdana",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        )),
                  ),
                  Divider(color: Colors.grey),
                ],
              );
            }));
  }

  Widget listUnverifiedParcel() {
    return Container(
        height: MediaQuery.of(context).size.height - 100,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: unverifiedResults.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderDetails(
                                    unverifiedResults[index]['id'])));
                      },
                      title: Text(
                          "Order #" +
                              Library()
                                  .numHash(
                                      int.parse(unverifiedResults[index]['id']))
                                  .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      subtitle: Text(unverifiedResults[index]['description'],
                          style: TextStyle(color: Colors.grey)),
                      trailing: Container(
                          width: 96,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      orderId = unverifiedResults[index]['id'];
                                      getOtp();
                                    });
                                  },
                                  icon: Icon(Icons.verified_rounded,
                                      color: Color(0xffe9b603))),
                              IconButton(
                                  onPressed: () {
                                    showAlertDialog(context,
                                        unverifiedResults[index]['id']);
                                  },
                                  icon: FaIcon(FontAwesomeIcons.timesCircle,
                                      color: Colors.white)),
                            ],
                          ))),
                  Divider(color: Colors.grey),
                ],
              );
            }));
  }

  Widget listParcel() {
    return Container(
        height: MediaQuery.of(context).size.height - 100,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetails(results[index]['id'])));
                    },
                    title: Text(
                        "Order #" +
                            Library()
                                .numHash(int.parse(results[index]['id']))
                                .toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    subtitle: Text(results[index]['description'],
                        style: TextStyle(color: Colors.grey)),
                    trailing: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size.fromWidth(100),
                          backgroundColor: Color(0xffe9b603),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrackParcelPage(
                                      results[index]['id'],
                                      results[index]['on_deliver'])));
                        },
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('View',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Verdana",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        )),
                  ),
                  Divider(color: Colors.grey),
                ],
              );
            }));
  }

  Future<void> unverifiedParcel() async {
    // Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "list_parcel.php";
    String sKey = Library().sKey;
    String tarStr = nonce + pageId + sKey;
    Digest hashTarStr = sha1.convert(utf8.encode(tarStr));
    String encTarStr = base64.encode(utf8.encode(hashTarStr.toString()));
    var postBody = {
      "unverified_parcel": nonce,
      'sKey': sKey,
      'userId': userId.toString()
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result[0] != "1") {
          setState(() {
            unverifiedResults = result;
            content3 = listUnverifiedParcel();
          });
        } else {
          setState(() {
            content3 = Center(
              child: Text("No results found",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
            );
          });
        }
      }
    } catch (ex) {
      Library().alertError(context, "Something wen't wrong");
    }
  }

  Future<void> cancelPendingRequest(parcelId) async {
    Navigator.pop(context);
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "list_parcel.php";
    String sKey = Library().sKey;

    var postBody = {
      "cancel_pending": nonce,
      'sKey': sKey,
      'userId': userId.toString(),
      'parcelId': parcelId
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] == "0") {
          Navigator.pop(context);
          Library()
              .alertError(context, "You've successfully cancelled the request");
          setState(() {
            listPending();
          });
        }
      }
    } catch (ex) {
      print(ex.toString());
      Library().alertError(context, "Something wen't wrong");
    }
  }

  Future<void> listPending() async {
    // Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "list_parcel.php";
    String sKey = Library().sKey;
    String tarStr = nonce + pageId + sKey;
    Digest hashTarStr = sha1.convert(utf8.encode(tarStr));
    String encTarStr = base64.encode(utf8.encode(hashTarStr.toString()));
    var postBody = {
      "pending_parcel": nonce,
      'sKey': sKey,
      'userId': userId.toString(),
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result[0] != "1") {
          setState(() {
            pendingResults = result;
            print("PENDING RESULTS");
            print(pendingResults);
            content2 = listPendingParcel();
          });
        } else {
          setState(() {
            content2 = Center(
              child: Text("No results found",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
            );
          });
        }
      }
    } catch (ex) {
      print(ex.toString());
      print("ERROR");
      Library().alertError(context, "Something wen't wrong");
    }
  }

  Future<void> listOnGoing() async {
    // Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "list_parcel.php";
    String sKey = Library().sKey;
    String tarStr = nonce + pageId + sKey;
    Digest hashTarStr = sha1.convert(utf8.encode(tarStr));
    String encTarStr = base64.encode(utf8.encode(hashTarStr.toString()));
    var postBody = {
      "list_parcel": nonce,
      'sKey': sKey,
      'userId': userId.toString(),
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result[0] != "1") {
          setState(() {
            results = result;
            content1 = listParcel();
          });
        } else {
          setState(() {
            content1 = Center(
              child: Text("No results found",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
            );
          });
        }
      }
    } catch (ex) {
      Library().alertError(context, "Something wen't wrong");
    }
  }

  Future<void> getOtp() async {
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "email_blasting/verify_pending.php";
    String sKey = Library().sKey;
    String tarStr = nonce + pageId + sKey;
    Digest hashTarStr = sha1.convert(utf8.encode(tarStr));
    String encTarStr = base64.encode(utf8.encode(hashTarStr.toString()));

    var postBody = {
      "get_otp": nonce,
      'sKey': sKey,
      'email': email.toString(),
      "tT": encTarStr,
    };
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      // Navigator.of(context).pop();
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] != '1') {
          var otp = result[0];
          print(result[0]);
          Navigator.of(context).pop();
          fullVerifyDialog(otp);
        } else {
          Navigator.pop(context);
          Library().alertError(context, "Something wen't wrong");
        }
      }
    } catch (ex) {
      print(ex.toString());
      Navigator.pop(context);
      Library().alertError(context, "Something wen't wrong");
    }
  }

  void fullVerifyDialog(otp) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Color(0xff363636),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color(0xff363636),
            ),
            body: Container(
              margin: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height - 100,
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
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Verification",
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
                      height: 150,
                      margin: EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35.0),
                        child: Image.asset('assets/src/checklist (1).png',
                            fit: BoxFit.contain),
                      )),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Enter here the code we sent to you regarding to your deliver request.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xff2c2c2c),
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.white),
                      ), // set rounded corner radius
                    ),
                    child: TextField(
                      controller: otpController,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: '',
                        hintStyle: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: Size.fromWidth(300),
                            backgroundColor: Color(0xffe9b603),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          onPressed: () {
                            if (otpController.text.isNotEmpty) {
                              print(otpController.text);
                              print(otp);
                              if (otpController.text.toString() !=
                                  otp.toString()) {
                                Library().alertError(context,
                                    "You have entered an invalid otp. Please try again or check your email regarding our message to you");
                              } else {
                                verifyParcel();
                              }
                            } else {
                              Library().alertError(context,
                                  "Please enter the otp we sent to you");
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Verify',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Verdana",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> verifyParcel() async {
    Navigator.pop(context);
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "verify_parcel.php";
    String sKey = Library().sKey;
    var postBody = {
      "verify_parcel": nonce,
      'sKey': sKey,
      'id': orderId,
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      // Navigator.of(context).pop();
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] == "0") {
          Navigator.pop(context);
          listPending();
          unverifiedParcel();
        }
      } else {
        Navigator.pop(context);
        Library().alertError(context, "Something wen't wrong");
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
      userId = setSharedPreds.getString('userId');
      email = setSharedPreds.getString('email');
    });
    listOnGoing();
    listPending();
    unverifiedParcel();
  }
}
