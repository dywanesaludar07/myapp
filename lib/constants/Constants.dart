import 'dart:convert';
import 'dart:math' as Math;
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatidapp/constants/spinkit.dart';
import 'package:http/http.dart' as http;

class Library {
  // final url = "http://192.168.1.132/";
  final url =
      "http://51.81.137.224/plesk-site-preview/www.ehatidcourierservices.com/https/51.81.137.224/";
  // final url = "http://ehatidcourierservices.epizy.com/";
  final String sKey = "2021_HatidAppApplication";

  postRequest(String url, postBody) async {
    final response = await http
        .post(Uri.parse(url), body: postBody)
        .timeout(Duration(seconds: 40));
    return response;
  }

  int numHash(int $inNum) {
    return (((0x0000FFFF & $inNum) << 16) + ((0xFFFF0000 & $inNum) >> 16));
  }

  void loadingDialog(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              insetPadding: EdgeInsets.all(5),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                      width: 77,
                      height: 77,
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.all(0),
                      child: Spinkit()),
                ],
              ))),
    );
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

  void alertError(BuildContext context, text) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("E-Hatid App"),
              content: Text(text),
              actions: [
                // Close the dialog
                CupertinoButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            ));
  }

  Future regenerateOtp(context) async {
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "email_blasting/signup.php";
    String sKey = Library().sKey;
    String tarStr = nonce + pageId + sKey;
    Digest hashTarStr = sha1.convert(utf8.encode(tarStr));
    String encTarStr = base64.encode(utf8.encode(hashTarStr.toString()));

    var postBody = {
      "createUser": nonce,
      "tT": encTarStr,
    };

    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      // Navigator.of(context).pop();

      if (response.statusCode == 200) {
        var resVal = jsonDecode(response.body);
        print(resVal);
        if (resVal[0] == '0') {
          Navigator.pop(context);
          return 0;
        } else {
          Navigator.pop(context);
          return 1;
        }
      }
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }
}
