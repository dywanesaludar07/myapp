import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/constants/bottombar.dart';
import 'package:hatidapp/constants/bottombar_riders.dart';
import 'package:hatidapp/constants/spinkit.dart';
import 'package:hatidapp/views/view_riders/image_receipt.dart';
import 'package:hatidapp/views/view_riders/image_view.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CompletionPage extends StatefulWidget {
  CompletionPageState createState() => CompletionPageState();
}

class CompletionPageState extends State<CompletionPage> {
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  String? userId;
  List details = [];
  String? parcelId;
  Widget detailsContainer = Container();
  bool list_ind = true;
  List detail = [];
  List historyDetails = [];
  bool recent = false;
  List hisdetails = [];
  TextEditingController addressController = new TextEditingController();
  Widget containerDetails = Container();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // listContainerHistory();
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
  }

  @override
  void initState() {
    super.initState();
    setPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff363636),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xffe9b603),
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [
          Container(
              decoration: BoxDecoration(
                color: Color(0xffe9b603),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35.0),
                    bottomRight: Radius.circular(35.0)),
              ),
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    "DELIVERY HISTORY",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ],
              )),
          Visibility(
            visible: list_ind,
            child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 7),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              recent = false;
                            });
                            getHistory();
                          },
                          child: Container(
                            margin: EdgeInsets.all(3),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade700, width: 1),
                              borderRadius: BorderRadius.circular(10),
                              color: !recent ? Colors.white : Color(0xff2c2c2c),
                            ),
                            child: Text(
                              "Today",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !recent ? Colors.black : Colors.white,
                                  fontSize: 15),
                            ),
                          ),
                        )),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 7),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              recent = true;
                            });
                            getRecentHistory();
                          },
                          child: Container(
                            margin: EdgeInsets.all(3),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade700, width: 1),
                              borderRadius: BorderRadius.circular(10),
                              color: recent ? Colors.white : Color(0xff2c2c2c),
                            ),
                            child: Text(
                              "Recently",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: recent ? Colors.black : Colors.white,
                                  fontSize: 15),
                            ),
                          ),
                        ))
                  ],
                )),
          ),
          containerDetails,
        ]),
        bottomNavigationBar: BottomBarRiders(2));
  }

  Widget detailsHistory() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        constraints: BoxConstraints(
          maxHeight: double.infinity,
        ),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade700, width: 1),
          borderRadius: BorderRadius.circular(17),
          color: Color(0xff2C2C2C),
          // boxShadow: [
          //   BoxShadow(color: Colors.green, spreadRadius: 3),
          // ],
        ),
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 7),
              ListTile(
                leading: Image.asset('assets/src/pickup.png'),
                title: Text(hisdetails[0]['account_name'],
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17)),
                subtitle: Text(
                  hisdetails[0]['sender_location'],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: Image.asset('assets/src/drop.png'),
                title: Text(hisdetails[0]['receiver_name'],
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17)),
                subtitle: Text(
                  hisdetails[0]['receiver_location'],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                title: Text("Collected From Sender",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17)),
                subtitle: Text(
                  "Php. " +
                      double.parse(hisdetails[0]['payment'])
                          .toStringAsFixed(2)
                          .toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                title: Text("Total Distance",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17)),
                subtitle: Text(
                  double.parse(hisdetails[0]['range'])
                          .toStringAsFixed(2)
                          .toString() +
                      " KM",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Visibility(
                  visible: hisdetails[0]['payment_method'] == "1",
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: Size.fromWidth(300),
                            backgroundColor: Color(0xffe9b603),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PageReceipt(
                                        Library().url +
                                            "pic_fetch.php/?width=500&url=" +
                                            Library()
                                                .numHash(int.parse(
                                                    hisdetails[0]['parcel_id']))
                                                .toString(),
                                        Library()
                                            .numHash(
                                                int.parse(hisdetails[0]['id']))
                                            .toString())));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Text('View Receipt',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Verdana",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          )),
                    ),
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      list_ind = true;
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
                    });
                    getHistory();
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    color: Colors.white,
                    size: 20,
                  ))
            ],
          ),
        ));
  }

  Future<void> getDetails(id) async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "get_history.php";
    String sKey = Library().sKey;
    var postBody = {
      'get_details': nonce,
      'sKey': sKey,
      'rider_id': userId.toString(),
      'id': id.toString()
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] != "0") {
          print("HISTORY DETAILS");
          print(result);
          setState(() {
            hisdetails = result;
            containerDetails = detailsHistory();
          });
        } else {
          setState(() {
            containerDetails = Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 70),
                  child: Text("No history",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey))),
            );
          });
        }
      }
    } catch (ex) {
      print(ex.toString());
      Library().alertError(context, "Something wen't wrong");
    }
  }

  Future<void> getHistory() async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "get_history.php";
    String sKey = Library().sKey;
    var postBody = {
      'get_history': nonce,
      'sKey': sKey,
      'rider_id': userId.toString(),
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] != "0") {
          print("HISTORY RESULT");
          print(result);
          setState(() {
            historyDetails = result;
            print(historyDetails.length);
            containerDetails = listHistory();
          });
        } else {
          setState(() {
            containerDetails = Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 70),
                  child: Text("No history",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey))),
            );
          });
        }
      }
    } catch (ex) {
      print(ex.toString());
      Library().alertError(context, "Something wen't wrong");
    }
  }

  Future<void> getRecentHistory() async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "get_history.php";
    String sKey = Library().sKey;
    var postBody = {
      'get_recent': nonce,
      'sKey': sKey,
      'rider_id': userId.toString(),
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] != "0") {
          print("HISTORY RESULT");
          print(result);
          setState(() {
            historyDetails = result;
            containerDetails = listRecent();
          });
        } else {
          setState(() {
            containerDetails = Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 70),
                  child: Text("No history",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey))),
            );
          });
        }
      }
    } catch (ex) {
      print(ex.toString());
      Library().alertError(context, "Something wen't wrong");
    }
  }

  Widget listRecent() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: MediaQuery.of(context).size.height - 350,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade700, width: 1),
          borderRadius: BorderRadius.circular(17),
          color: Color(0xff2C2C2C),
          // boxShadow: [
          //   BoxShadow(color: Colors.green, spreadRadius: 3),
          // ],
        ),
        child: Container(
            height: 500,
            child: ListView.builder(
                itemCount: historyDetails.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          list_ind = false;
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
                          getDetails(historyDetails[index]['id']);
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.all(10),
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade700, width: 1),
                            borderRadius: BorderRadius.circular(17),
                            color: Color(0xff363636),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 1),
                                    child: Text(
                                      "Delivery Completion",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 15),
                                    ),
                                  ),
                                  Visibility(
                                    visible: historyDetails[index]
                                            ['payment_type'] ==
                                        "0",
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        "Paid Via Cash",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                      visible: historyDetails[index]
                                              ['payment_type'] ==
                                          "1",
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "Paid Via GCash",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      )),
                                  Visibility(
                                      visible: historyDetails[index]
                                              ['payment_type'] ==
                                          "2",
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "Paid Via PayMaya",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      )),
                                  Visibility(
                                      visible: historyDetails[index]
                                              ['payment_type'] ==
                                          "3",
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "Paid Via CoinsPh",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      )),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      DateFormat.yMMMd()
                                              .format(DateTime.parse(
                                                  historyDetails[index]
                                                      ['created_date']))
                                              .toString() +
                                          " - " +
                                          DateFormat.Hm()
                                              .format(DateTime.parse(
                                                  historyDetails[index]
                                                      ['created_date']))
                                              .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "+ " +
                                      double.parse(historyDetails[index]
                                              ['delivery_fee'])
                                          .toStringAsFixed(2)
                                          .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                              )
                            ],
                          )));
                })));
  }

  Widget listHistory() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: MediaQuery.of(context).size.height - 350,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade700, width: 1),
          borderRadius: BorderRadius.circular(17),
          color: Color(0xff2C2C2C),
          // boxShadow: [
          //   BoxShadow(color: Colors.green, spreadRadius: 3),
          // ],
        ),
        child: Container(
            height: 500,
            child: ListView.builder(
                itemCount: historyDetails.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          list_ind = false;
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
                          getDetails(historyDetails[index]['id']);
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.all(10),
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade700, width: 1),
                            borderRadius: BorderRadius.circular(17),
                            color: Color(0xff363636),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    child: Text(
                                      "Delivery Completion",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 15),
                                    ),
                                  ),
                                  Visibility(
                                    visible: historyDetails[index]
                                            ['payment_type'] ==
                                        "0",
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        "Paid Via Cash",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                      visible: historyDetails[index]
                                              ['payment_type'] ==
                                          "1",
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "Paid Via GCash",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      )),
                                  Visibility(
                                      visible: historyDetails[index]
                                              ['payment_type'] ==
                                          "2",
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "Paid Via PayMaya",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      )),
                                  Visibility(
                                      visible: historyDetails[index]
                                              ['payment_type'] ==
                                          "3",
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "Paid Via CoinsPh",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      )),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      DateFormat.yMMMd()
                                              .format(DateTime.parse(
                                                  historyDetails[index]
                                                      ['created_date']))
                                              .toString() +
                                          " - " +
                                          DateFormat.Hm()
                                              .format(DateTime.parse(
                                                  historyDetails[index]
                                                      ['created_date']))
                                              .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "+ " +
                                      double.parse(historyDetails[index]
                                              ['delivery_fee'])
                                          .toStringAsFixed(2)
                                          .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                              )
                            ],
                          )));
                })));
  }

  void listContainerHistory() {
    setState(() {
      containerDetails = listHistory();
    });
  }

  setPref() async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    setState(() {
      userId = setSharedPreds.getString('riderId');
      parcelId = setSharedPreds.getString('parcelId');
    });
    getHistory();
  }
}
