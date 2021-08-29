import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/constants/bottombar.dart';
import 'dart:convert';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:hatidapp/views/coins.dart';
import 'package:hatidapp/views/gcash.dart';
import 'package:hatidapp/views/paymaya.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  static final String tokenizationKey = 'sandbox_38k3g4rx_x8w6jtn4jjcn6cqv';
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  String? userId = '';
  Widget containerDetails = Container();
  Widget pickContainer = Container();
  Widget dropContainer = Container();
  Widget finishContainer = Container();
  List datas = [];
  List dataPick = [];
  List data2 = [];
  List listDone = [];
  @override
  void initState() {
    super.initState();
    containerDetails = SpinKitRotatingCircle(
      color: Colors.white,
      size: 20.0,
    );

    pickContainer = SpinKitRotatingCircle(
      color: Colors.white,
      size: 20.0,
    );
    setPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff363636),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Color(0xff363636),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height - 200,
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
                  "Notifications",
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
              height: MediaQuery.of(context).size.height - 330,
              child: DefaultTabController(
                length: 4,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Color(0xff363636),
                  appBar: AppBar(
                    backgroundColor: Color(0xff363636),
                    bottom: TabBar(
                      tabs: [
                        Tab(child: Text("To Pay")),
                        Tab(child: Text("To Pick")),
                        Tab(child: Text("Drop")),
                        Tab(child: Text("Done")),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      containerDetails,
                      pickContainer,
                      dropContainer,
                      finishContainer
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(3),
    );
  }

  Widget pickWidget() {
    return Container(
        height: 400,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: dataPick.length,
            itemBuilder: (context, index) {
              return Column(children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                      color: Colors.white,
                      child: ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Color(0xffe9b603),
                              child: FaIcon(FontAwesomeIcons.bell,
                                  color: Colors.white)),
                          title: Text(
                            dataPick[index]['description'] +
                                " - " +
                                dataPick[index]['pickup_location'] +
                                " - " +
                                dataPick[index]['drop_location'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              'Rider of your parcel is arrive at the pick up point'),
                          trailing: FaIcon(FontAwesomeIcons.envelopeOpen,
                              size: 17, color: Colors.blue.shade400)),
                    ),
                ),
                Divider(color: Colors.grey),
              ]);
            }));
  }

  Widget doneWidget() {
    return Container(
        height: 400,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: listDone.length,
            itemBuilder: (context, index) {
              return Column(children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                      color: Colors.white,
                      child: ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Color(0xffe9b603),
                              child: FaIcon(FontAwesomeIcons.bell,
                                  color: Colors.white)),
                          title: Text(
                            listDone[index]['description'] +
                                " - " +
                                listDone[index]['pickup_location'] +
                                " - " +
                                listDone[index]['drop_location'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle:
                              Text('The parcel were delivered successfully'),
                          trailing: FaIcon(FontAwesomeIcons.envelopeOpen,
                              size: 17, color: Colors.blue.shade400)),
                    ),
                ),
                Divider(color: Colors.grey),
              ]);
            }));
  }

  Widget dropWidget() {
    return Container(
        height: 400,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: data2.length,
            itemBuilder: (context, index) {
              return Column(children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                      color: Colors.white,
                      child: ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Color(0xffe9b603),
                              child: FaIcon(FontAwesomeIcons.bell,
                                  color: Colors.white)),
                          title: Text(
                            data2[index]['description'] +
                                " - " +
                                data2[index]['pickup_location'] +
                                " - " +
                                data2[index]['drop_location'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              'Rider of your parcel is arrive at the pick up point'),
                          trailing: FaIcon(FontAwesomeIcons.envelopeOpen,
                              size: 17, color: Colors.blue.shade400)),
                    ),
                ),
                Divider(color: Colors.grey),
              ]);
            }));
  }

  Widget detailsWidget() {
    return Container(
        height: 400,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: datas.length,
            itemBuilder: (context, index) {
              return Column(children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                      color: Colors.white,
                      child: ListTile(
                          onTap: () {
                            if (datas[index]['payment_method'] == "1") {
                              showCupertinoModalPopup<void>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CupertinoActionSheet(
                                        title: const Text('Choose Payment'),
                                        message: const Text(
                                            'You can choose atleast one type of payment you prefer'),
                                        actions: <CupertinoActionSheetAction>[
                                          CupertinoActionSheetAction(
                                            child: const Text('G-Cash',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Gcash(datas[index]
                                                              ['id'])));
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: const Text('Paymaya',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PayMaya(datas[index]
                                                              ['id'])));
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: const Text('Coins Ph',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CoinsPh(datas[index]
                                                              ['id'])));
                                            },
                                          )
                                        ],
                                      ));
                            } else {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (_) => CupertinoAlertDialog(
                                        title: Text("E-Hatid App"),
                                        content: Text(
                                            "The payment you've set for this parcel is Via Cash on Delivery. Do you want to make it online instead?"),
                                        actions: [
                                          // Close the dialog
                                          CupertinoButton(
                                              child: Text("Pay via cash"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              }),
                                          CupertinoButton(
                                            child: Text('Change payment type'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showCupertinoDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      CupertinoAlertDialog(
                                                        title:
                                                            Text("E-Hatid App"),
                                                        content: Text(
                                                            "Do you really want to change payment type?"),
                                                        actions: [
                                                          // Close the dialog
                                                          CupertinoButton(
                                                              child: Text("No"),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              }),
                                                          CupertinoButton(
                                                            child: Text('Yes'),
                                                            onPressed: () {
                                                              changeType(
                                                                  datas[index]
                                                                      ['id']);
                                                            },
                                                          )
                                                        ],
                                                      ));
                                            },
                                          )
                                        ],
                                      ));
                            }

                            // final request = BraintreeDropInRequest(
                            //   tokenizationKey: tokenizationKey,
                            //   collectDeviceData: true,
                            //   googlePaymentRequest:
                            //       BraintreeGooglePaymentRequest(
                            //     totalPrice:
                            //         (double.parse(datas[index]['total_fee']) /
                            //                 50)
                            //             .toString(),
                            //     currencyCode: 'USD',
                            //     billingAddressRequired: false,
                            //   ),
                            //   paypalRequest: BraintreePayPalRequest(
                            //     amount:
                            //         (double.parse(datas[index]['total_fee']) /
                            //                 50)
                            //             .toString(),
                            //     displayName: 'E-Hatid Application',
                            //   ),
                            // );
                            // BraintreeDropInResult res =
                            //     await BraintreeDropIn.start(request);

                            // if (res != null) {
                            //   try {
                            //     const pageId = 'paypal.php';
                            //     String url = Library().url + "/" + pageId;

                            //     var postBody = {
                            //       'nonce': res.paymentMethodNonce.nonce,
                            //       'device': res.deviceData,
                            //       'payment':
                            //           (double.parse(datas[index]['total_fee']) /
                            //                   50)
                            //               .toString(),
                            //     };
                            //     print(postBody);
                            //     http.Response response =
                            //         await Library().postRequest(url, postBody);

                            //     if (response.statusCode == 200) {
                            //       var result = jsonDecode(response.body);
                            //       print(result);
                            //     }
                            //   } catch (ex) {
                            //     print(ex.toString());
                            //   }
                            // }
                          },
                          leading: CircleAvatar(
                              backgroundColor: Color(0xffe9b603),
                              child: FaIcon(FontAwesomeIcons.bell,
                                  color: Colors.white)),
                          title: Text(
                            datas[index]['description'] +
                                " - " +
                                datas[index]['pickup_location'] +
                                " - " +
                                datas[index]['drop_location'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              'Your request has been verified. Click here to complete your payment'),
                          trailing: FaIcon(FontAwesomeIcons.envelopeOpen,
                              size: 17, color: Colors.blue.shade400)),
                    ),
                ),
                Divider(color: Colors.grey),
              ]);
            }));
  }

  Future<void> changeType(id) async {
    Navigator.pop(context);
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "parcel_details.php";
    String sKey = Library().sKey;
    var postBody = {
      "to_change": nonce,
      'sKey': sKey,
      'id': id.toString(),
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print("CHANGEd");
        print(result);
        if (result[0] == "0") {
          Navigator.pop(context);
          parcelDetails();
          Library().alertError(context,
              "Payment type successfuly change. You can now choose between Gcash, Paymaya or Coins Ph");
        } else {
          Navigator.pop(context);
          showCupertinoDialog(
              context: context,
              builder: (_) => CupertinoAlertDialog(
                    title: Text("E-Hatid App"),
                    content: Text("Something wen't wrong please try again"),
                    actions: [
                      CupertinoButton(
                        child: Text('Submit'),
                        onPressed: () {
                          changeType(id);
                        },
                      )
                    ],
                  ));
        }
      }
    } catch (ex) {
      Navigator.pop(context);
      Library().alertError(context, "Something went wrong");
      print(ex.toString());
    }
  }

  Future<void> dropDetails() async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "parcel_details.php";
    String sKey = Library().sKey;
    var postBody = {
      "to_drop": nonce,
      'sKey': sKey,
      'userId': userId.toString(),
    };
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] != "1") {
          setState(() {
            data2 = result;
            print("PARCEL DATA");
            print(datas);
            dropContainer = dropWidget();
          });
        } else {
          setState(() {
            dropContainer = Center(
                child: Text("No results found",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)));
          });
        }
      }
    } catch (ex) {
      Library().alertError(context, "Something went wrong");
      print(ex.toString());
    }
  }

  Future<void> parcelDetails() async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "parcel_details.php";
    String sKey = Library().sKey;
    var postBody = {
      "to_pay": nonce,
      'sKey': sKey,
      'userId': userId.toString(),
    };
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] != "1") {
          setState(() {
            datas = result;
            print("PARCEL DATA");
            print(datas);
            containerDetails = detailsWidget();
          });
        } else {
          setState(() {
            containerDetails = Center(
                child: Text("No results found",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)));
          });
        }
      }
    } catch (ex) {
      Library().alertError(context, "Something went wrong");
      print(ex.toString());
    }
  }

  Future<void> finish() async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "parcel_details.php";
    String sKey = Library().sKey;
    var postBody = {
      "to_finish": nonce,
      'sKey': sKey,
      'userId': userId.toString(),
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result);

        if (result[0] != "1") {
          setState(() {
            listDone = result;
            finishContainer = doneWidget();
          });
        } else {
          setState(() {
            finishContainer = Center(
                child: Text("No results found",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)));
          });
        }
      }
    } catch (ex) {
      Library().alertError(context, "Something went wrong");
      print(ex.toString());
    }
  }

  Future<void> pickDetails() async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "parcel_details.php";
    String sKey = Library().sKey;
    var postBody = {
      "to_pick": nonce,
      'sKey': sKey,
      'userId': userId.toString(),
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result);

        if (result[0] != "1") {
          setState(() {
            dataPick = result;
            pickContainer = pickWidget();
          });
        } else {
          setState(() {
            pickContainer = Center(
                child: Text("No results found",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)));
          });
        }
      }
    } catch (ex) {
      Library().alertError(context, "Something went wrong");
      print(ex.toString());
    }
  }

  setPref() async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    setState(() {
      userId = setSharedPreds.getString('userId');
      parcelDetails();
      pickDetails();
      dropDetails();
      finish();
    });
  }
}
