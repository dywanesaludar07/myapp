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
import 'package:hatidapp/views/order_details.dart';
import 'package:hatidapp/views/view_riders/ongoin_parcel.dart';
import 'package:hatidapp/views/view_riders/order_rider.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RequestPage extends StatefulWidget {
  RequestPageState createState() => RequestPageState();
}

class RequestPageState extends State<RequestPage> {
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  String? userId;
  List details = [];
  List sender_id = [];
  List res = [];
  String senderId = '';
  Widget detailsContainer = Container();
  TextEditingController addressController = new TextEditingController();
  Location? location;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? currentLocation;
  LocationData? destinationLocation;
  Widget container1 = Container();
  Widget container2 = Container();
  String parcelId = '';
  List detail = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    container1 = SpinKitRotatingCircle(
      color: Colors.white,
      size: 20.0,
    );
    container2 = SpinKitRotatingCircle(
      color: Colors.white,
      size: 20.0,
    );
  }

  @override
  void initState() {
    super.initState();
    setPref();
    location = new Location();

    location?.changeSettings(accuracy: LocationAccuracy.LOW, interval: 20000);

    getLocation();

    // location?.onLocationChanged().listen((LocationData cLoc) {
    //   currentLocation = cLoc;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xff363636),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Delivery Request",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          backgroundColor: Color(0xffe9b603),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Container(
                  padding: EdgeInsets.all(5),
                  child: Text("Nearby Requests",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Container(
                  padding: EdgeInsets.all(5),
                  child: Text("Other Requests",
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        body: TabBarView(
          children: [container1, container2],
        ),
        bottomNavigationBar: BottomBarRiders(0),
      ),
    );
  }

  void showAlertDialog(BuildContext context, id, senderid) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("E-Hatid App"),
              content: Text("Do you really want to accept this parcel?"),
              actions: [
                // Close the dialog
                CupertinoButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                CupertinoButton(
                  child: Text('Accept'),
                  onPressed: () {
                    setState(() {
                      parcelId = id;
                      senderId = senderid;
                    });
                    acceptParcel(id);
                  },
                )
              ],
            ));
  }

  void refreshDialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("E-Hatid App"),
              content: Text("Something went wrong please try again"),
              actions: [
                CupertinoButton(
                  child: Text('Refresh'),
                  onPressed: () {
                    listParcel();
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  Future<void> acceptParcel(id) async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "accept_parcel.php";
    String sKey = Library().sKey;
    var postBody = {
      'accept_parcel': nonce,
      'sKey': sKey,
      'rider_id': userId.toString(),
      'parcel_id': id
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      // Navigator.of(context).pop();
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] == "0") {
          setParcelId(id);
          Navigator.pop(context);
          Library().alertError(context, "You have accepted this request");
          arrive();
          listParcel();
        } else {
          Library().alertError(context, "Something went wrong");
        }
      }
    } catch (ex) {
      print(ex.toString());
      Library().alertError(context, "Something went wrong");
    }
  }

  void getLocation() async {
    _serviceEnabled = await location!.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location!.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location!.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location!.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }

    currentLocation = await location?.getLocation();
  }

  Future<void> listParcel() async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "list_parcel.php";
    String sKey = Library().sKey;
    var postBody = {'pending_parcel': nonce, 'sKey': sKey};
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      // Navigator.of(context).pop();
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] != "1") {
          res = result;
          setState(() {
            sender_id = [];
          });
          for (var i in res) {
            var distance = Library().getDistanceFromLatLonInKm(
              currentLocation?.latitude,
              currentLocation?.longitude,
              double.parse(i['sender_lat']),
              double.parse(i['sender_long']),
            );

            if (distance <= 20) {
              sender_id.add(i['id']);
            }
          }
          print(sender_id);
          setState(() {
            container1 = requestWidget();
            container2 = requestOthers();
          });
          // print(res);
        } else {
          setState(() {
            container1 = Center(
              child: Text("No nearby request available",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
            );
            container2 = Center(
              child: Text("No other request available",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
            );
          });
        }
      }
    } catch (ex) {
      refreshDialog(context);
      print(ex.toString());
    }
  }

  Widget requestOthers() {
    return Container(
        height: MediaQuery.of(context).size.height - 100,
        width: MediaQuery.of(context).size.width,
        child: RefreshIndicator(
            child: ListView.builder(
                itemCount: res.length,
                itemBuilder: (context, index) {
                  return Visibility(
                      visible: !sender_id.contains(res[index]['id']),
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OrderRider(res[index]['id'])));
                            },
                            title: Text(
                                res[index]['account_name'] +
                                    " is requesting for delivery",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            subtitle: Text(
                                res[index]['pickup_location'] +
                                    " to " +
                                    res[index]['drop_location'],
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
                                  print(res[index]['sender_id']);
                                  if (detail[0] == "1") {
                                    showAlertDialog(context, res[index]['id'],
                                        res[index]['sender_id']);
                                  } else {
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (_) => CupertinoAlertDialog(
                                              title: Text("E-Hatid App"),
                                              content: Text(
                                                  "You still have on going delivery. Please finish it first!"),
                                              actions: [
                                                CupertinoButton(
                                                  child: Text(
                                                      'Go to On Going Delivery'),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                OnGoingPage()));
                                                  },
                                                )
                                              ],
                                            ));
                                  }
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
                          Divider(color: Colors.grey),
                        ],
                      ));
                }),
            onRefresh: refresh));
  }

  Future<Null> refresh() async {
    listParcel();
  }

  Widget requestWidget() {
    return Container(
        height: MediaQuery.of(context).size.height - 100,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: res.length,
            itemBuilder: (context, index) {
              return Visibility(
                  visible: sender_id.contains(res[index]['id']),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OrderRider(res[index]['id'])));
                        },
                        title: Text(
                            res[index]['account_name'] +
                                " is requesting for delivery",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        subtitle: Text(
                            res[index]['pickup_location'] +
                                " to " +
                                res[index]['drop_location'],
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
                              if (detail[0] == "1") {
                                showAlertDialog(context, res[index]['id'],
                                    res[index]['sender_id']);
                              } else {
                                showCupertinoDialog(
                                    context: context,
                                    builder: (_) => CupertinoAlertDialog(
                                          title: Text("E-Hatid App"),
                                          content: Text(
                                              "You still have on going delivery. Please finish it first!"),
                                          actions: [
                                            CupertinoButton(
                                              child: Text(
                                                  'Go to On Going Delivery'),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OnGoingPage()));
                                              },
                                            )
                                          ],
                                        ));
                              }
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
                      Divider(color: Colors.grey),
                    ],
                  ));
            }));
  }

  void removeItemsById(arr, id) {
    var i = arr.length;
    if (i) {
      // (not 0)
      while (--i) {
        var cur = arr[i];
        if (cur.id == id) {
          arr.splice(i, 1);
        }
      }
    }
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
        detail = result;
      }
    } catch (ex) {
      print("ERRR");
      Library().alertError(context, "Something went wrong");
      print(ex.toString());
    }
  }

  Future<void> arrive() async {
    Navigator.pop(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "notify_parcel.php";
    String sKey = Library().sKey;
    var postBody = {
      'arrive_parcel': nonce,
      'sKey': sKey,
      'rider_id': userId.toString(),
      'notif_type': '0',
      'parcel_id': parcelId,
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
              "We've successfully notify them that you accepted the request");
          listParcel();
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

  setParcelId(id) async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    setSharedPreds.setString('parcelId', id);
  }

  setPref() async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    setState(() {
      userId = setSharedPreds.getString('riderId');
    });

    parcelDetails();
    listParcel();
  }
}
