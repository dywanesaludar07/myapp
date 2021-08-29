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

class CoinsPh extends StatefulWidget {
  final String orderId;
  CoinsPh(this.orderId);
  CoinsPhState createState() => CoinsPhState(this.orderId);
}

class CoinsPhState extends State<CoinsPh> {
  final String orderId;
  CoinsPhState(this.orderId);
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
        backgroundColor: Color(0xff0f59ae),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                height: 50,
                image: NetworkImage(
                    "http://content.coins.ph/wp-content/uploads/2020/06/white-logo_blue-bg.png"))
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
                  "How to Use Coins Ph for Ehatid - App: A Complete Beginner's Guide",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                    "On the Mobile App, here's how to send money to another wallet.",
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text("1. Get the number of the rider you book for this parcel"),
                SizedBox(height: 10),
                Text(
                    "2. Make sure to double check number of rider before you proceed"),
                SizedBox(height: 10),
                Text('3. Tap the "Send" icon on the app'),
                SizedBox(height: 10),
                Text('4. Select "Send to another Coins account"'),
                SizedBox(height: 10),
                Text(
                    "5. Enter the recipients Coins.ph registered mobile number or email address, or recipient's valid wallet address"),
                SizedBox(height: 10),
                Text(
                    "6. Enter the amount and the purpose of the transaction. After confirming the details, slide to send to complete transaction"),
                SizedBox(height: 10),
                Text("7. Screenshot or download the receipt of your payment",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(
                    "8. Attach the file(s) below ( E-hatid application ) and click pay",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Text(
                    "On the Coins Ph website, here's how to send money to another wallet.",
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text(
                  '1. Click on the source wallet of your choice and click "Send"',
                ),
                SizedBox(height: 10),
                Text(
                  "2. Enter the amount, the recipient's Coins.ph registered mobile number or emaila address or recipient's valid wallet address, and the purpose of the transaction",
                ),
                SizedBox(height: 10),
                Text(
                  "3. Review the details of your transaction and click Send to complete the transaction",
                ),
                SizedBox(height: 10),
                Text("4. Screenshot or download the receipt of your payment",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(
                    "5. Attach the file(s) below ( E-hatid application ) and click pay",
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
        ..fields['payment_type'] = '3'
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
                                content: Text("Your receipt was sent. Please wait for the verification of the rider"),
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
