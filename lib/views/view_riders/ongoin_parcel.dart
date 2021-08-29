import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/constants/bottombar.dart';
import 'package:hatidapp/constants/bottombar_riders.dart';
import 'package:hatidapp/views/view_riders/feedback.dart';
import 'package:hatidapp/views/view_riders/image_view.dart';
import 'package:hatidapp/views/view_riders/request_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OnGoingPage extends StatefulWidget {
  OnGoingPageState createState() => OnGoingPageState();
}

class OnGoingPageState extends State<OnGoingPage> {
  late bool _serviceEnabled;
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  String? userId;
  List details = [];
  String? parcelId;
  Widget detailsContainer = Container();
  String orderId = '';
  List detail = [];
  TextEditingController addressController = new TextEditingController();
  Widget containerDetails = Container();
  String arr = '1';
  String going = '2';
  String finish = '3';
  List notifs = [];
  String payment_type = '';
  String senderId = '';
  late Timer _timer;
  Position? position;

  void startTimer() {
    const oneSec = const Duration(seconds: 2);
    _timer = new Timer.periodic(
      oneSec,
      (Timer _timer) {
        parcelDetails();
        checkPayment();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    containerDetails = SpinKitRotatingCircle(
      color: Colors.white,
      size: 20.0,
    );
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
        body: containerDetails,
        bottomNavigationBar: BottomBarRiders(1));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
  }

  Future<void> parcelDetails() async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "parcel_details.php";
    String sKey = Library().sKey;
    var postBody = {
      'parcel_on_going': nonce,
      'sKey': sKey,
      'rider_id': userId.toString()
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      // Navigator.of(context).pop();
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] != "1") {
          setState(() {
            detail = result;
            orderId = detail[0]['id'];
            payment_type = detail[0]['payment_method'];
            senderId = detail[0]['sender_id'];
            notifParcel();
            // if (payment_type == '1') {
            //   if (detail[0]['pay_cat'] == '0') {
            //     startTimer();
            //   } else {
            //     _timer.cancel();
            //   }
            // } else {
            //   _timer.cancel();
            // }
          });
        } else {
          setState(() {
            containerDetails = Center(
              child: Text("No on going delivery. Choose another",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
            );
          });
        }
      }
    } catch (ex) {
      print("ERRR");
      print(ex.toString());
    }
  }

  Widget detailWidget() {
    return Column(
      children: [
        Banner(
          message: detail[0]['pay_cat'] == '0' ? "NOT PAID" : "PAID",
          location: BannerLocation.topEnd,
          color: Colors.red,
          child: Container(
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
                    "DELIVERY CONTACT",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Text(
                    "Request Number " +
                        "#" +
                        Library()
                            .numHash(int.parse(detail[0]['id']))
                            .toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 2),
                  Text(
                    payment_type == "0" ? "Cash on Delivery" : "Via online",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              )),
        ),
        Divider(
          color: Colors.grey,
        ),
        Container(
          height: 415,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              ListTile(
                leading: Image.asset('assets/src/pickup.png'),
                title: Text(
                    detail[0]['pickup_location'] +
                        " - " +
                        detail[0]['staddress'],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(
                    detail[0]['account_name'] +
                        " - " +
                        detail[0]['contact_number'],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: Image.asset('assets/src/drop.png'),
                title: Text(
                    detail[0]['drop_location'] +
                        " - " +
                        detail[0]['staddress2'],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(
                    detail[0]['receiver_name'] +
                        " - " +
                        detail[0]['receiver_contact'],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              Divider(
                color: Colors.grey,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: notifs.contains(arr)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Arrive at Pick Up Point",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 17)),
                            SizedBox(width: 4),
                            FaIcon(FontAwesomeIcons.check,
                                size: 17, color: Colors.white)
                          ],
                        )
                      : OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: Size.fromWidth(300),
                            backgroundColor: Color(0xffe9b603),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          onPressed: () {
                            showAlertDialog(context, "1");
                          },
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text('Arrive at Pick Up Point',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Verdana",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          )),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: notifs.contains(going)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Going to Drop Off Point",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 17)),
                            SizedBox(width: 4),
                            FaIcon(FontAwesomeIcons.check,
                                size: 17, color: Colors.white)
                          ],
                        )
                      : OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: Size.fromWidth(300),
                            backgroundColor: Color(0xffe9b603),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          onPressed: () {
                            if (notifs.contains(arr)) {
                              showAlertDialog(context, "2");
                            } else {
                              Library().alertError(context,
                                  "You are not yet done with the first step of delivery");
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text('Going to Drop Off Point',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Verdana",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          )),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: notifs.contains(finish)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Delivery Finished",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 17)),
                            SizedBox(width: 4),
                            FaIcon(FontAwesomeIcons.check,
                                size: 17, color: Colors.white)
                          ],
                        )
                      : OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: Size.fromWidth(300),
                            backgroundColor: Color(0xffe9b603),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          onPressed: () {
                            if (notifs.contains(going)) {
                              showAlertDialog(context, "3");
                            } else {
                              Library().alertError(context,
                                  "You are not yet done with the first step of delivery");
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(11),
                            child: Text('Finish Delivery',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Verdana",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          )),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size.fromWidth(300),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      onPressed: () {
                        if (detail[0]['pay_cat'] == '1') {
                          Library().alertError(context,
                              "You can't cancel this delivery the sender already pay the fee");
                        } else {
                          removeDialog(context);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(11),
                        child: Text('Cancel',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Verdana",
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      )),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void showAlertDialog(BuildContext context, id) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("E-Hatid App"),
              content: Text("Procceed to this action?"),
              actions: [
                // Close the dialog
                CupertinoButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                CupertinoButton(
                  child: Text('Procceed'),
                  onPressed: () {
                    arrive(id);
                  },
                )
              ],
            ));
  }

  void removeDialog(BuildContext context) {
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
                    removeDelivery();
                  },
                )
              ],
            ));
  }

  Future<void> arrive(notif) async {
    Navigator.pop(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "notify_parcel.php";
    String sKey = Library().sKey;
    var postBody = {
      'arrive_parcel': nonce,
      'sKey': sKey,
      'rider_id': userId.toString(),
      'notif_type': notif,
      'parcel_id': orderId,
      'senderId': senderId,
      'read_flg': '0',
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] == "0") {
          Library().alertError(context,
              "We've successfully notify them that you are in pick up point");
          getCurrentPosition();
          notifParcel();
          if (notif == "3") {
            finishDelivery();
          }
        }
      } else {
        Library().alertError(context, "Something wen't wrong");
      }
      // Navigator.of(context).pop();
    } catch (ex) {
      print(ex.toString());
      Library().alertError(context, "Something wen't wrong");
    }
  }

  Future<void> getCurrentPosition() async {
    position = await _determinePosition();
    print(position!.latitude);
    print(position!.longitude);

    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "set_location.php";
    String sKey = Library().sKey;
    var postBody = {
      'set_location': nonce,
      'sKey': sKey,
      'rider_id': userId.toString(),
      'latitude': position!.latitude.toString(),
      'longitude': position!.longitude.toString(),
      'parcel_id': orderId,
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] == "0") {
          print("INSERTED");
        } else {
          Library().alertError(context, "Something went wrong");
        }
      }
    } catch (ex) {
      print(ex.toString());
      Library().alertError(context, "Something went wrong");
    }
  }

  Future<void> finishDelivery() async {
    Navigator.pop(context);
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "remove_parcel.php";
    String sKey = Library().sKey;
    var postBody = {
      'finish_delivery': nonce,
      'sKey': sKey,
      'rider_id': userId.toString(),
      'parcel_id': orderId,
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        print("FINISHHH");
        print(res);
        if (res[0] == "0") {
          Navigator.pop(context);
          showCupertinoDialog(
              context: context,
              builder: (_) => CupertinoAlertDialog(
                    title: Text("E-Hatid App"),
                    content: Text(
                        "Delivery for this parcel is now finished. You can now pick other delivery"),
                    actions: [
                      // Close the dialog
                      CupertinoButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FeedBack(orderId)));
                          }),
                    ],
                  ));
        }
      } else {
        Navigator.pop(context);
        Library().alertError(context, "Something went wrong");
      }
    } catch (ex) {
      print(ex.toString());
      Navigator.pop(context);
      Library().alertError(context, "Something went wrong");
    }
  }

  Future<void> removeDelivery() async {
    Navigator.pop(context);
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "remove_parcel.php";
    String sKey = Library().sKey;
    var postBody = {
      'remove_parcel': nonce,
      'sKey': sKey,
      'rider_id': userId.toString(),
      'parcel_id': orderId,
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        if (res[0] == "0") {
          Navigator.pop(context);
          Library().alertError(context, "You have canceled the request");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => RequestPage()));
        }
      }
    } catch (ex) {
      print(ex.toString());
      Library().alertError(context, "Something went wrong");
    }
  }

  Future<void> checkPayment() async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "check_payment.php";
    String sKey = Library().sKey;
    var postBody = {
      'checkPayment': nonce,
      'sKey': sKey,
      'rider_id': userId.toString(),
      'parcel_id': orderId,
    };
    print(orderId);
    print(postBody);
    try {
      String payType = '0';
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print("results here");
        print(result);
        if (result[0] != "err_no") {
          if (result[0]['payment_method'] == "1") {
            setState(() {
              if (result[0]['payment_type'] == "1") {
                payType = 'Message from Gcash';
                _timer.cancel();
              } else if (result[0]['payment_type'] == "2") {
                payType = 'Message from PayMaya';
                _timer.cancel();
              } else if (result[0]['payment_type'] == "3") {
                payType = 'Message from Coins PH';
                _timer.cancel();
              }
            });
            showCupertinoDialog(
                context: context,
                builder: (_) => CupertinoAlertDialog(
                      title: Text(payType.toString()),
                      content: Text(
                          "The sender of this parcel sents you a payment for this delivery. To check the details please click the view button below"),
                      actions: [
                        // Close the dialog
                        CupertinoButton(
                            child: Text('View'),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PageViewImage(
                                          Library().url +
                                              "pic_fetch.php/?width=900&url=" +
                                              Library()
                                                  .numHash(int.parse(orderId))
                                                  .toString(),
                                          orderId)));
                            }),
                        CupertinoButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              startTimer();
                            }),
                      ],
                    ));
          } else {
            Library().alertError(context,
                "Sender will pay you via Cash on Delivery you can now proceed to delivery");
            _timer.cancel();
          }
        } else {
          _timer.cancel();
        }
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  Future<void> notifParcel() async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "notify_parcel.php";
    String sKey = Library().sKey;
    var postBody = {
      'notif_parcel': nonce,
      'sKey': sKey,
      'rider_id': userId.toString(),
      'parcel_id': orderId,
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result);
        if (result[0] != "empty") {
          setState(() {
            notifs.clear();
            for (var notif in result) {
              notifs.add(notif['notif_type']);
            }

            containerDetails = detailWidget();
          });

          print(notifs);
        } else {
          setState(() {
            containerDetails = Center(
              child: Text("No on going delivery. Choose another",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
            );
          });
        }
      } else {
        Library().alertError(context, "Something wen't wrong");
      }
      // Navigator.of(context).pop();
    } catch (ex) {
      print(ex.toString());
      Library().alertError(context, "Something wen't wrong");
    }
  }

  Widget ongoingNone() {
    return Center(
      child: Text(
        "No on going delivery found",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),
      ),
    );
  }

  setPref() async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    setState(() {
      userId = setSharedPreds.getString('riderId');
      parcelId = setSharedPreds.getString('parcelId');
    });
    parcelDetails();
    startTimer();
  }
}
