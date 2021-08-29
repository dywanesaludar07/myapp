import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

class PolyLines extends StatefulWidget {
  final id;
  final riderName;
  PolyLines(this.id, this.riderName);
  @override
  _MapScreenState createState() => _MapScreenState(this.id,this.riderName);
}

class _MapScreenState extends State<PolyLines> {
  final id;
  final riderName;
  _MapScreenState(this.id,this.riderName);
  late GoogleMapController mapController;
  Location? location;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  // double _originLatitude = 6.5212402, _originLongitude = 3.3679965;
  // double _destLatitude = 6.849660, _destLongitude = 3.648190;
  double _originLatitude = 14.4140, _originLongitude = 120.8572;
  double _destLatitude = 14.4080, _destLongitude = 120.8492;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyAeIzrWtQomTTb3XMtWnYLTKkqte5nMmzE";
  LocationData? currentLocation;
  late CameraPosition initialCameraPosition;
  Widget mapContainer = Container();
  @override
  void initState() {
    super.initState();
    location = new Location();
    location?.changeSettings(accuracy: LocationAccuracy.NAVIGATION);
    mapContainer = SpinKitRotatingCircle(
      color: Colors.black,
      size: 60.0,
    );
    getRiderPosition();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: FaIcon(FontAwesomeIcons.times, color: Color(0xffe9b603)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              "Rider's Location",
              style: TextStyle(
                  color: Color(0xffe9b603), fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color(0xff363636),
          ),
          body: mapContainer),
    );
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

    _addMarker(LatLng(currentLocation?.latitude, currentLocation?.longitude),
        "origin", BitmapDescriptor.defaultMarkerWithHue(50), "You");

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90), riderName.toString());
    _getPolyline();
  }

  Widget mapWidget() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation?.latitude, currentLocation?.longitude),
          zoom: 14,
          tilt: 80,
          bearing: 30),
      myLocationEnabled: false,
      tiltGesturesEnabled: true,
      compassEnabled: true,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      onMapCreated: _onMapCreated,
      markers: Set<Marker>.of(markers.values),
      polylines: Set<Polyline>.of(polylines.values),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    // mapController.showMarkerInfoWindow(MarkerId("origin"));
    // mapController.showMarkerInfoWindow(MarkerId("destination"));
  }

  Future<void> getRiderPosition() async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "set_location.php";
    String sKey = Library().sKey;
    var postBody = {
      'get_location': nonce,
      'sKey': sKey,
      'parcel_id': id.toString()
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] != "1") {
          setState(() {
            _destLatitude = double.parse(result[0]['lat_rider']);
            _destLongitude = double.parse(result[0]['long_rider']);
          });
          getLocation();
        } else {
          Library().alertError(context, "Something went wrong");
        }
      }
    } catch (ex) {
      print(ex.toString());
      Library().alertError(context, "Something went wrong");
    }
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor, name) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
      infoWindow: InfoWindow(title: name),
    );
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        width: 4,
        color: Color.fromARGB(255, 40, 122, 198),
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
    setState(() {
      mapContainer = mapWidget();
    });
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(currentLocation!.latitude, currentLocation!.longitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
