import 'dart:convert';
import 'dart:ui';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/views/list_parcel.dart';
import 'package:hatidapp/views/track_parcel.dart';
import 'package:hatidapp/views/verification_parcel.dart';
import 'package:hatidapp/views/view_riders/profile_viewer.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:hatidapp/constants/bottombar.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SendParcel extends StatefulWidget {
  SendParcelState createState() => SendParcelState();
}

class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.simpleCurrency(locale: "pt_Br");

    String newText = formatter.format(value / 100);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}

class SendParcelState extends State<SendParcel> {
  Location? location;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? currentLocation;
  LocationData? destinationLocation;
  String? userId;
  int? groupValue = 0;
  final results = '';
  double lat = 0;
  double long = 0;
  double lat2 = 0;
  double long2 = 0;
  double distance = 0;
  bool? valueAsap = false;
  bool? valueAddress = false;
  List<String> places = [];
  int? typePayment = 0;
  TextEditingController searchController = new TextEditingController();
  TextEditingController searchReceiverController = new TextEditingController();
  TextEditingController feeController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController pickUpController = new TextEditingController();
  TextEditingController staddressController = new TextEditingController();
  TextEditingController receiverController = new TextEditingController();
  TextEditingController receiverContact = new TextEditingController();
  TextEditingController staddress2 = new TextEditingController();
  TextEditingController deliveryFee = new TextEditingController();
  TextEditingController otpController = new TextEditingController();
  String orderId = '';
  static const double CAMERA_ZOOM = 16; //16
  static const double CAMERA_TILT = 5; // 80
  static const double CAMERA_BEARING = 30;
  LatLng dest_location = LatLng(14.4279, 120.8801);
  LatLng SOURCE_LOCATION = LatLng(0, 0);
  String account = '';
  String email = '';
  String usercategory = '';
  String myAddress = '';
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  // for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints? polylinePoints;
  String googleAPIKey = 'AIzaSyAeIzrWtQomTTb3XMtWnYLTKkqte5nMmzE';
  // for my custom marker pins
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;
  late CameraPosition initialCameraPosition;
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  Widget profileContainer = Container();
  @override
  void initState() {
    super.initState();
    profileContainer = SpinKitRotatingCircle(
      color: Colors.white,
      size: 50.0,
    );
    setPref();
  }

  void _handleValue(int? value) {
    setState(() {
      groupValue = value;
      print(groupValue);
    });
  }

  void _handlePayment(int? value) {
    setState(() {
      typePayment = value;
      print(typePayment);
    });
  }

  void _handleAsapValue(bool? value) {
    setState(() {
      valueAsap = value;
    });
  }

  void _handleCurrentAddress(bool? value) {
    setState(() {
      if (value!) {
        valueAddress = value;
        searchLocation(myAddress);
      } else {
        valueAddress = value;
        lat = 0;
        long = 0;
        searchController.text = '';
        feeController.text = '0.00';
      }
    });
  }

  void showPinsOnMap() {
    var pinPosition =
        LatLng(currentLocation?.latitude, currentLocation?.longitude);
    // get a LatLng out of the LocationData object
    var destPosition =
        LatLng(destinationLocation?.latitude, destinationLocation?.longitude);
    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: sourceIcon));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    setPolylines();
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints!.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(currentLocation!.latitude, currentLocation!.longitude),
      PointLatLng(
          destinationLocation!.latitude, destinationLocation!.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polylines.add(Polyline(
            width: 5, // set the width of the polylines
            polylineId: PolylineId('poly'),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates));
      });
    }
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
        body: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Color(0xffe9b603),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35.0),
                      bottomRight: Radius.circular(35.0)),
                ),
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    SizedBox(width: 5),
                    profileContainer,
                    SizedBox(width: 5),
                    Container(
                        margin: EdgeInsets.only(top: 40),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Hello, " + account + "!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 25),
                              ),
                            ),
                            Container(
                                width: 150,
                                child: Center(
                                  child: Text(
                                    "Ready to send your parcel? Just fill the form below",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                )),
                          ],
                        ))
                  ],
                )),
            SizedBox(height: 10),
            Container(
                height: 380,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          decoration: BoxDecoration(
                            color: Color(0xff2c2c2c),
                            border: Border.all(
                                color: Colors.grey, // set border color
                                width: 1.0), // set border width
                            borderRadius: BorderRadius.all(Radius.circular(
                                30.0)), // set rounded corner radius
                          ),
                          child: TextField(
                            maxLength: 30,
                            controller: descriptionController,
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              hintText: 'Product Description',
                              counterText: '',
                              hintStyle: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Transform.scale(
                              scale: 1.5,
                              child: Radio(
                                  value: 0,
                                  groupValue: groupValue,
                                  onChanged: _handleValue,
                                  activeColor: Color(0xffe9b603)),
                            ),
                            new Text(
                              'Fragile',
                              style: new TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Transform.scale(
                              scale: 1.5,
                              child: Radio(
                                  value: 1,
                                  groupValue: groupValue,
                                  onChanged: _handleValue,
                                  activeColor: Color(0xffe9b603)),
                            ),
                            new Text(
                              'Not Fragile',
                              style: new TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: valueAddress! == false,
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            decoration: BoxDecoration(
                              color: Color(0xff2c2c2c),
                              border: Border.all(
                                  color: Colors.grey, // set border color
                                  width: 1.0), // set border width
                              borderRadius: BorderRadius.all(Radius.circular(
                                  30.0)), // set rounded corner radius
                            ),
                            child: TextField(
                              controller: searchController,
                              onChanged: (input) {
                                setState(() {
                                  lat = 0;
                                  long = 0;
                                });
                                initalPlace(input);
                              },
                              onSubmitted: (val) {
                                searchLocation(val);
                                places = [];
                              },
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                hintText: "Pick Up Location",
                                counterText: '',
                                hintStyle: TextStyle(
                                    fontSize: 17.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: usercategory == '1',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  checkColor: Colors.greenAccent,
                                  activeColor: Colors.red,
                                  value: valueAddress,
                                  onChanged: _handleCurrentAddress,
                                ),
                                new Text(
                                  'Use my current address instead',
                                  style: new TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )),
                        Visibility(
                            visible: lat == 0 && searchController.text != '',
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                width: MediaQuery.of(context).size.width - 10,
                                height: 200,
                                child: ListView.builder(
                                    itemCount: places.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          places[index],
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        leading: FaIcon(
                                          FontAwesomeIcons.mapMarkerAlt,
                                          color: Color(0xffe9b603),
                                        ),
                                        onTap: () {
                                          searchController.text = places[index];
                                          searchLocation(places[index]);
                                          places = [];
                                        },
                                      );
                                    }))),
                        Visibility(
                          visible: searchController.text != '',
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            decoration: BoxDecoration(
                              color: Color(0xff2c2c2c),
                              border: Border.all(
                                  color: Colors.grey, // set border color
                                  width: 1.0), // set border width
                              borderRadius: BorderRadius.all(Radius.circular(
                                  30.0)), // set rounded corner radius
                            ),
                            child: TextField(
                              controller: staddressController,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                hintText:
                                    "Street / Home Number/ Blk / Room / Bldng",
                                counterText: '',
                                hintStyle: TextStyle(
                                    fontSize: 17.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          decoration: BoxDecoration(
                            color: Color(0xff2c2c2c),
                            border: Border.all(
                                color: Colors.grey, // set border color
                                width: 1.0), // set border width
                            borderRadius: BorderRadius.all(Radius.circular(
                                30.0)), // set rounded corner radius
                          ),
                          child: TextField(
                            maxLength: 30,
                            controller: receiverController,
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              hintText: "Receiver's Name",
                              counterText: '',
                              hintStyle: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          decoration: BoxDecoration(
                            color: Color(0xff2c2c2c),
                            border: Border.all(
                                color: Colors.grey, // set border color
                                width: 1.0), // set border width
                            borderRadius: BorderRadius.all(Radius.circular(
                                30.0)), // set rounded corner radius
                          ),
                          child: TextField(
                            maxLength: 15,
                            controller: receiverContact,
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              hintText: "Receiver's Contact Number",
                              counterText: '',
                              hintStyle: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          decoration: BoxDecoration(
                            color: Color(0xff2c2c2c),
                            border: Border.all(
                                color: Colors.grey, // set border color
                                width: 1.0), // set border width
                            borderRadius: BorderRadius.all(Radius.circular(
                                30.0)), // set rounded corner radius
                          ),
                          child: TextField(
                            controller: searchReceiverController,
                            onChanged: (input) {
                              setState(() {
                                lat2 = 0;
                                long2 = 0;
                              });
                              initalPlace(input);
                            },
                            onSubmitted: (val) {
                              searchLocation(val);
                              places = [];
                            },
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              hintText: "Drop Off Location",
                              counterText: '',
                              hintStyle: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Visibility(
                            visible: lat2 == 0 &&
                                searchReceiverController.text != '',
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                width: MediaQuery.of(context).size.width - 10,
                                height: 200,
                                child: ListView.builder(
                                    itemCount: places.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          places[index],
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        leading: FaIcon(
                                          FontAwesomeIcons.mapMarkerAlt,
                                          color: Color(0xffe9b603),
                                        ),
                                        onTap: () {
                                          searchReceiverController.text =
                                              places[index];
                                          searchLocation(places[index]);
                                          places = [];
                                        },
                                      );
                                    }))),
                        Visibility(
                          visible: searchReceiverController.text != '',
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            decoration: BoxDecoration(
                              color: Color(0xff2c2c2c),
                              border: Border.all(
                                  color: Colors.grey, // set border color
                                  width: 1.0), // set border width
                              borderRadius: BorderRadius.all(Radius.circular(
                                  30.0)), // set rounded corner radius
                            ),
                            child: TextField(
                              controller: staddress2,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                hintText:
                                    "Street / Home Number/ Blk / Room / Bldng",
                                counterText: '',
                                hintStyle: TextStyle(
                                    fontSize: 17.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Transform.scale(
                              scale: 1.5,
                              child: Radio(
                                  value: 0,
                                  groupValue: typePayment,
                                  onChanged: _handlePayment,
                                  activeColor: Color(0xffe9b603)),
                            ),
                            new Text(
                              'Cash on Delivery',
                              style: new TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Transform.scale(
                              scale: 1.5,
                              child: Radio(
                                  value: 1,
                                  groupValue: typePayment,
                                  onChanged: _handlePayment,
                                  activeColor: Color(0xffe9b603)),
                            ),
                            new Text(
                              'Online Payment',
                              style: new TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          decoration: BoxDecoration(
                            color: Color(0xff2c2c2c),
                            border: Border.all(
                                color: Colors.grey, // set border color
                                width: 1.0), // set border width
                            borderRadius: BorderRadius.all(Radius.circular(
                                30.0)), // set rounded corner radius
                          ),
                          child: TextField(
                            maxLength: 30,
                            controller: feeController,
                            readOnly: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              // Fit the validating format.
                              //fazer o formater para dinheiro
                              CurrencyInputFormatter()
                            ],
                            decoration: InputDecoration(
                              prefixIcon: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: Image.network(
                                  'https://images-na.ssl-images-amazon.com/images/I/911AzHbWiPL.png',
                                ),
                              ),
                              contentPadding: EdgeInsets.all(8),
                              hintText: "Delivery Fee",
                              counterText: '',
                              hintStyle: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              checkColor: Colors.greenAccent,
                              activeColor: Colors.red,
                              value: valueAsap,
                              onChanged: _handleAsapValue,
                            ),
                            new Text(
                              'Pick Up Now / ASAP',
                              style: new TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                fixedSize: Size.fromWidth(300),
                                backgroundColor: Color(0xffe9b603),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                side: BorderSide(width: 1, color: Colors.white),
                              ),
                              onPressed: () {
                                if (descriptionController.text.isEmpty ||
                                    searchController.text.isEmpty ||
                                    staddress2.text.isEmpty ||
                                    staddressController.text.isEmpty ||
                                    searchReceiverController.text.isEmpty ||
                                    receiverController.text.isEmpty ||
                                    receiverContact.text.isEmpty) {
                                  Library().alertError(context,
                                      "All informations must be fill up first");
                                } else {
                                  showAlertDialog(context);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('Send Request',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "Verdana",
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ),
                      ],
                    ))),
            Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      "Scroll for complete registration info",
                      style: TextStyle(color: Colors.white),
                    ))),
          ],
        ),
        bottomNavigationBar: BottomBar(0));
  }

  void showAlertDialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("E-Hatid App"),
              content: Text(
                  "Please double check all the informations you've entered before you click save"),
              actions: [
                // Close the dialog
                CupertinoButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                CupertinoButton(
                  child: Text('Save'),
                  onPressed: () {
                    sendRequest();
                  },
                )
              ],
            ));
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

    location = new Location();
    currentLocation = await location?.getLocation();
  }

  Future<void> searchLocation(searchText) async {
    String apiKey = 'AIzaSyAeIzrWtQomTTb3XMtWnYLTKkqte5nMmzE';
    String url =
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?";
    // http.Response response = await Library().postRequest(url, postBody);
    final http.Response response = await http.get(Uri.parse(url +
        'input=$searchText&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=$apiKey'));
    try {
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> result = jsonDecode(response.body);
          print("RESULT LOCATION");
          print(result);
          List<dynamic> data = result["candidates"];
          if (lat != 0) {
            lat2 = data[0]['geometry']['location']['lat'];
            long2 = data[0]['geometry']['location']['lng'];

            if (lat != 0 && lat2 != 0) {
              double fee = 0;
              double totalFee = 50;
              fee = getDistanceFromLatLonInKm(lat, long, lat2, long2) * 6;
              totalFee = totalFee + fee;

              feeController.text = totalFee.toStringAsFixed(2).toString();
            } else {
              feeController.text = '0.00';
            }
          } else {
            lat = data[0]['geometry']['location']['lat'];
            long = data[0]['geometry']['location']['lng'];

            if (lat2 != 0 && lat != 0) {
              double fee = 0;
              double totalFee = 50;
              fee = getDistanceFromLatLonInKm(lat, long, lat2, long2) * 6;
              totalFee = totalFee + fee;

              feeController.text = totalFee.toStringAsFixed(2).toString();
            } else {
              feeController.text = '0.00';
            }
          }
        });
      } else {
        print("Err");
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  clear() {
    setState(() {
      descriptionController.text = '';
      searchController.text = '';
      staddressController.text = '';
      receiverController.text = '';
      searchReceiverController.text = '';
      staddress2.text = '';
      receiverContact.text = '';
      feeController.text = '0.00';
      valueAsap = false;
      groupValue = 0;
    });
  }

  Future<void> verifyParcel() async {
    Navigator.pop(context);
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "verify_parcel.php";
    String sKey = Library().sKey;
    String tarStr = nonce + pageId + sKey;
    Digest hashTarStr = sha1.convert(utf8.encode(tarStr));
    String encTarStr = base64.encode(utf8.encode(hashTarStr.toString()));
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ListParcelPage()));
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

  Future<void> sendRequest() async {
    Navigator.pop(context);
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "email_blasting/register_parcel.php";
    String sKey = Library().sKey;
    String tarStr = nonce + pageId + sKey;
    Digest hashTarStr = sha1.convert(utf8.encode(tarStr));
    String encTarStr = base64.encode(utf8.encode(hashTarStr.toString()));
    print("DISTANCE");
    print("DISTANCE");
    print("DISTANCE");
    print("DISTANCE");
    print("DISTANCE");
    print(getDistanceFromLatLonInKm(lat, long, lat2, long2).toString());
    var postBody = {
      "registerParcel": nonce,
      'sKey': sKey,
      'description': descriptionController.text,
      'quality': groupValue.toString(),
      'pickLocation': searchController.text,
      'address1': staddressController.text,
      'receiverName': receiverController.text,
      'dropLocation': searchReceiverController.text,
      'address2': staddress2.text,
      'receiverContact': receiverContact.text,
      'paymentMethod': typePayment.toString(),
      'fee': feeController.text,
      'category': valueAsap == false ? '0' : '1',
      'userId': userId.toString(),
      'lat1': lat.toString(),
      'long1': long.toString(),
      'lat2': lat2.toString(),
      'long2': long2.toString(),
      'email': email.toString(),
      'range': getDistanceFromLatLonInKm(lat, long, lat2, long2).toString(),
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
          print(result);
          setState(() {
            orderId = result[1];
          });
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

  Future<void> initalPlace(input) async {
    String apiKey = 'AIzaSyAeIzrWtQomTTb3XMtWnYLTKkqte5nMmzE';
    var session = '1234567890';
    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?";
    // http.Response response = await Library().postRequest(url, postBody);
    final http.Response response = await http.get(Uri.parse(
        url + 'input=$input&key=$apiKey&radius=1000&sessiontoken=$session'));
    try {
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> result = jsonDecode(response.body);
          List<dynamic> data = result["predictions"];
          places = [];
          for (var i = 0; i < data.length; i++) {
            places.add(data[i]['description']);
          }
        });
      } else {
        print("Err");
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1); // deg2rad below
    var dLon = deg2rad(lon2 - lon1);
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) *
            Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c; // Distance in km
    return double.parse((d).toStringAsFixed(2));
  }

  deg2rad(deg) {
    return deg * (Math.pi / 180);
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

  void fullScreenDialog() {
    initialCameraPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      target: SOURCE_LOCATION,
      bearing: CAMERA_BEARING,
    );
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation?.latitude, currentLocation?.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }
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
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon:
                      FaIcon(FontAwesomeIcons.times, color: Color(0xffe9b603)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  "Nearby Riders",
                  style: TextStyle(
                      color: Color(0xffe9b603), fontWeight: FontWeight.bold),
                ),
                backgroundColor: Color(0xff363636),
              ),
              body: Stack(
                children: [
                  GoogleMap(
                      myLocationEnabled: true,
                      compassEnabled: true,
                      tiltGesturesEnabled: false,
                      markers: _markers,
                      padding: EdgeInsets.all(30),
                      polylines: _polylines,
                      mapType: MapType.normal,
                      initialCameraPosition: initialCameraPosition,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        showPinsOnMap();
                      }),
                ],
              ));
        });
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
          width: 120.0,
          height: 120.0,
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

  void evictImage(url) {
    final NetworkImage provider = NetworkImage(url);
    provider.evict().then<void>((bool success) {
      if (success) debugPrint('removed image!');
    });
  }

  Future<void> getUserDetails() async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "user_details.php";
    String sKey = Library().sKey;

    var postBody = {
      "get_details": nonce,
      'sKey': sKey,
      'userId': userId,
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      // Navigator.of(context).pop();
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print("USER DETAILS");
        print(result);
        if (result[0] != "0") {
          setState(() {
            email = result[0]['email_address'];
            account = result[0]['account_name'];
            usercategory = result[0]['account_type'];
            myAddress = result[0]['address'];
            var temp = account.split(" ");
            account = temp[0];
            print(account);
            setEmailPref();
          });
        }
      }
    } catch (ex) {
      print(ex.toString());
      Library().alertError(context, "Something went wrong");
    }
  }

  setEmailPref() async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    setState(() {
      setSharedPreds.setString("email", email.toString());
    });
  }

  setPref() async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    setState(() {
      userId = setSharedPreds.getString('userId');
      evictImage(Library().url +
          "dp_sender.php/?width=900&url=" +
          Library().numHash(int.parse(userId!)).toString());
      profileContainer = setProfile();
      getUserDetails();
    });
  }
}
