import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/constants/bottombar.dart';
import 'package:hatidapp/constants/bottombar_riders.dart';
import 'package:hatidapp/views/view_riders/completion.dart';
import 'package:hatidapp/views/view_riders/image_receipt.dart';
import 'package:hatidapp/views/view_riders/image_view.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FeedBack extends StatefulWidget {
  final String orderId;
  FeedBack(this.orderId);
  FeedBackState createState() => FeedBackState(this.orderId);
}

class FeedBackState extends State<FeedBack> {
  final String orderId;
  FeedBackState(this.orderId);
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  String? userId;
  TextEditingController feedbackController = new TextEditingController();
  @override
  void initState() {
    super.initState();
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
      body: Column(children: [
        Container(
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
                  "FEEDBACK",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ],
            )),
        SizedBox(
          height: 30,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 5),
            child: Text(
              "Your feedback is important to us!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xffACACAC),
                  fontSize: 20),
            )),
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          height: 200,
          decoration: BoxDecoration(
            color: Color(0xff2c2c2c),
            border: Border.all(
                color: Colors.grey, // set border color
                width: 1.0), // set border width
            borderRadius: BorderRadius.all(
                Radius.circular(30.0)), // set rounded corner radius
          ),
          child: TextField(
            style: TextStyle(fontSize: 17, color: Colors.white),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: feedbackController,
            decoration: InputDecoration(
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
          margin: EdgeInsets.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  fixedSize: Size.fromWidth(100),
                  backgroundColor: Color(0xff2c2c2c),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  side: BorderSide(width: 1, color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompletionPage()));
                },
                child: Text('Cancel',
                    style: TextStyle(
                        color: Color(0xffe9b603), fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                width: 20,
              ),
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
                  if (feedbackController.text.length == 0) {
                    Library().alertError(context,
                        "You must provide a feedback before you submit");
                  } else {
                    showCupertinoDialog(
                        context: context,
                        builder: (_) => CupertinoAlertDialog(
                              title: Text("E-Hatid App"),
                              content: Text("Submit this feedback?"),
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
                                    submitFeedBack();
                                  },
                                )
                              ],
                            ));
                  }
                },
                child: Text("Submit",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        )
      ]),
    );
  }

  Future<void> submitFeedBack() async {
    Navigator.pop(context);
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "feedback.php";
    String sKey = Library().sKey;
    var postBody = {
      'send_feedback': nonce,
      'sKey': sKey,
      'rider_id': userId.toString(),
      'feedback': feedbackController.text,
      'orderId': orderId,
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result[0] == "0") {
          Navigator.pop(context);
          Library().alertError(context, "Your feedback was submitted");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CompletionPage()));
        } else {
          Navigator.pop(context);
          Library()
              .alertError(context, "Feedback not submitted. Please try again");
        }
      } else {
        Navigator.pop(context);
        Library().alertError(context, "Something wen't wrong");
      }
    } catch (ex) {
      Navigator.pop(context);
      Library().alertError(context, "Something wen't wrong");
    }
  }

  setPref() async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    setState(() {
      userId = setSharedPreds.getString('riderId');
    });
  }
}
