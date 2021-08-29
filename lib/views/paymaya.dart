import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/views/notifications.dart';
import 'package:http/http.dart' as http;

class PayMaya extends StatefulWidget {
  final String orderId;
  PayMaya(this.orderId);
  PayMayaState createState() => PayMayaState(this.orderId);
}

class PayMayaState extends State<PayMaya> {
  final String orderId;
  PayMayaState(this.orderId);
  bool _loadingPath = false;
  String? filePaths;
  String? fileNames;

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );

    try {
      if (result != null) {
        // File file = File(result.files.single.path!);
        if (fileNames == result.files.single.name) {
          Library().alertError(context, "File already exist");
        } else {
          fileNames = result.files.single.name;
          filePaths = result.files.single.path!;
        }

        setState(() => _loadingPath = false);
      } else {
        setState(() => _loadingPath = false);
      }
    } on PlatformException catch (e) {
      print(e.toString());
      Library().alertError(context, "File format not supported");
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff152323),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xff152323),
              backgroundImage: NetworkImage(
                  "https://www.ciit.edu.ph/wp-content/uploads/2018/07/PayMaya-logo-apps-for-millennials.png"),
            ),
            SizedBox(width: 5),
            Text(
              "PayMaya",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
        actions: [
          IconButton(
              icon: const FaIcon(FontAwesomeIcons.home, color: Colors.white),
              tooltip: 'Back to app',
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationPage()));
              }),
        ],
      ),
      body: Container(
          margin: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "How to Use PayMaya for Ehatid - App: A Complete Beginner's Guide",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text("1. Get the number of the rider you book for this parcel"),
                SizedBox(height: 10),
                Text(
                    "2. Make sure to double check number of rider before you proceed"),
                SizedBox(height: 10),
                Text(
                    "3. Open then PayMaya Application. ( Please note: Make sure your account is verified for you to pay using this app)"),
                SizedBox(height: 10),
                Text(
                    "4. Enter the credentials you need for login in PayMaya App. (PIN, Fingerprint or etc.)"),
                SizedBox(height: 10),
                Text(
                    "5. Tap More (bottom right on IOS) or Menu (top left on Android), then tap Send Money"),
                SizedBox(height: 10),
                Text(
                    "6. Enter your recipient's Mobile Number or Account Number"),
                SizedBox(height: 10),
                Text(
                    "7. Enter the amount you want to send. ( As long as this amount is less than your total PayMaya account balance, it's fine!)"),
                SizedBox(height: 10),
                Text("8. Select PayMaya"),
                SizedBox(height: 10),
                Text(
                  "9. Add on optional message to your money gift and tap Continue",
                ),
                SizedBox(height: 10),
                Text(
                  "10. Check your transaction details one last time and tap Send",
                ),
                SizedBox(height: 10),
                Text(
                  "11. Wait for an in-app information and SMS from PayMaya to make sure the money's sent",
                ),
                SizedBox(height: 10),
                Text("9. Screenshot or download the receipt of your payment",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(
                    "10. Attach the file(s) below ( E-hatid application ) and click pay",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                IconButton(
                    onPressed: () {
                      _openFileExplorer();
                    },
                    icon: FaIcon(FontAwesomeIcons.paperclip,
                        color: Colors.grey, size: 30)),
                Visibility(
                    visible: fileNames == null,
                    child: Text("Attach receipt here",
                        style: TextStyle(color: Colors.grey))),
                Visibility(
                  visible: fileNames != null,
                  child: ListTile(
                    title: Text(fileNames.toString(),
                        style: TextStyle(color: Colors.grey)),
                    trailing: IconButton(
                      icon: FaIcon(FontAwesomeIcons.times),
                      onPressed: () {
                        setState(() {
                          fileNames = null;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size.fromWidth(100),
                    backgroundColor: Color(0xffe9b603),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    side: BorderSide(width: 1, color: Colors.white),
                  ),
                  onPressed: () {
                    if (fileNames == null) {
                      Library().alertError(
                          context, "Please include the attachment needed");
                    } else {
                      showCupertinoDialog(
                          context: context,
                          builder: (_) => CupertinoAlertDialog(
                                title: Text("E-Hatid App"),
                                content: Text("Submit this receipt?"),
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
                                      pay();
                                    },
                                  )
                                ],
                              ));
                    }
                  },
                  child: Text("Pay",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 10),
                Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade700, width: 3),
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xff2c2c2c),
                    ),
                    child: Text(
                      "Please note: Make sure to click the pay button for complete payment process",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    ))
              ],
            ),
          )),
    );
  }

  Future<void> pay() async {
    Navigator.pop(context);
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "payment_details.php";
    String sKey = Library().sKey;

    try {
      String url = Library().url + "/" + pageId;
      var req = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['fileName'] = Library().numHash(int.parse(orderId)).toString()
        ..fields['orderId'] = orderId.toString()
        ..fields['sendPayment'] = nonce
        ..fields['sKey'] = sKey
        ..fields['payment_type'] = '2'
        ..files.add(http.MultipartFile.fromBytes(
            'fileImage', File(filePaths!).readAsBytesSync(),
            filename: fileNames.toString()));

      var response = await req.send();
      if (response.statusCode == 200) {
        var result = await http.Response.fromStream(response);
        var res = jsonDecode(result.body);
        if (res[0] == "0") {
          Navigator.pop(context);
          showCupertinoDialog(
              context: context,
              builder: (_) => CupertinoAlertDialog(
                    title: Text("E-Hatid App"),
                    content: Text(
                        "Your receipt was sent. Please wait for the verification of the rider"),
                    actions: [
                      // Close the dialog
                      CupertinoButton(
                          child: Text('Okay'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationPage()));
                          }),
                    ],
                  ));
        } else {
          Navigator.pop(context);
          Library().alertError(
              context, "Invalid sending of payment. Please try again");
        }
      }
    } catch (ex) {
      print(ex.toString());
      Navigator.pop(context);
      Library().alertError(context, "Something went wrong");
    }
  }
}
