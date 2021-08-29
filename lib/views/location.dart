import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';

class LocationIdentifier extends StatefulWidget {
  LocationIdentifierState createState() => LocationIdentifierState();
}

class LocationIdentifierState extends State<LocationIdentifier> {
  Location? location;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? currentLocation;
  LocationData? destinationLocation;
  static const double CAMERA_ZOOM = 16; //16
  static const double CAMERA_TILT = 5; // 80
  static const double CAMERA_BEARING = 30;
  LatLng dest_location = LatLng(14.4279, 120.8801);
  LatLng SOURCE_LOCATION = LatLng(0, 0);
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
  String lat = '', long = '';
  @override
  void initState() {
    super.initState();
    location = new Location();
    polylinePoints = PolylinePoints();
    //GET REAL TIME LOCATION OF USERS
    location?.changeSettings(
        accuracy: LocationAccuracy.BALANCED, interval: 20000);

    location?.onLocationChanged().listen((LocationData cLoc) {
      currentLocation = cLoc;
      updatePinOnMap();
    });
    setSourceAndDestinationIcons();
    getLocation();
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

    // currentLocation = await location?.getLocation();
    SOURCE_LOCATION =
        LatLng(currentLocation?.latitude, currentLocation?.longitude);
    destinationLocation = LocationData.fromMap({
      "latitude": dest_location.latitude,
      "longitude": dest_location.longitude
    });
  }

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
              myLocationEnabled: false,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              markers: _markers,
              polylines: _polylines,
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                showPinsOnMap();
              })
        ],
      ),
    );
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
        icon: BitmapDescriptor.defaultMarker));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    setPolylines();
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation?.latitude, currentLocation?.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition =
          LatLng(currentLocation?.latitude, currentLocation?.longitude);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition, // updated position
          icon: BitmapDescriptor.defaultMarker));
    });
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

  void setSourceAndDestinationIcons() async {
    // sourceIcon = await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(devicePixelRatio: 1, size: Size.fromHeight(10)),
    //     'assets/src/pickup.png',
    //     mipmaps: false);

    destinationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 1),
      'assets/src/pickup.png',
    );
  }
}
