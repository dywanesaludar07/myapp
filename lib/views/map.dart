import 'dart:convert';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';

class GooglePlaces extends StatefulWidget {
  GooglePlaceState createState() => GooglePlaceState();
}

class GooglePlaceState extends State<GooglePlaces> {
  final results = '';
  double lat = 0;
  double long = 0;
  double lat2 = 0;
  double long2 = 0;
  double distance = 0;
  List<String> places = [];
  TextEditingController searchController = new TextEditingController();
  @override
  void initState() {
    initalPlace("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("GOOGLE PLACE")),
        body: Container(
          child: Column(children: [
            TextField(
              controller: searchController,
              onChanged: (input) {
                initalPlace(input);
              },
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: ListView.builder(
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(places[index]),
                        leading: FaIcon(FontAwesomeIcons.locationArrow),
                        onTap: () {
                          searchLocation(places[index]);
                          places = [];
                        },
                      );
                    })),
            Text("LATITUDE: " + lat.toString()),
            Text("LONGHITUDE: " + long.toString()),
            Text("LATITUDE 2: " + lat2.toString()),
            Text("LONGHITUDE 2: " + long2.toString()),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    distance =
                        getDistanceFromLatLonInKm(lat, long, lat2, long2);
                  });
                },
                child: Text("CALCULATE DISTANCE")),
            Text("CALCULATED DISTANCE" + distance.toString())
          ]),
        ));
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
          List<dynamic> data = result["candidates"];
          if (lat != 0) {
            lat2 = data[0]['geometry']['location']['lat'];
            long2 = data[0]['geometry']['location']['lng'];
          } else {
            lat = data[0]['geometry']['location']['lat'];
            long = data[0]['geometry']['location']['lng'];
          }
        });
      } else {
        print("Err");
      }
    } catch (ex) {
      print(ex.toString());
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
}
