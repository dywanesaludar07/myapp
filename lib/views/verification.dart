import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/views/login.dart';
import 'package:hatidapp/views/send_parcel.dart';
import 'package:hatidapp/views/signup.dart';
import 'package:http/http.dart' as http;

class VerificationPage extends StatefulWidget {
  final postBody;
  final int otp;
  VerificationPage(this.postBody, this.otp);
  VerificationPageState createState() =>
      VerificationPageState(this.postBody, this.otp);
}

class VerificationPageState extends State<VerificationPage> {
  final postBody;
  final int myOtp;
  VerificationPageState(this.postBody, this.myOtp);

  TextEditingController otp = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff363636),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Color(0xff363636),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                icon: FaIcon(FontAwesomeIcons.arrowLeft))
          ],
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
                  height: 200,
                  margin:
                      EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35.0),
                    child: Image.asset('assets/src/approve.png',
                        fit: BoxFit.contain),
                  )),
              Container(
                margin: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Enter the verification code we sent to your account',
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
                  controller: otp,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                  decoration: InputDecoration(
                    hintText: '',
                    hintStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size.fromWidth(300),
                        backgroundColor: Color(0xffe9b603),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      onPressed: () {
                        if (otp.text.toString() != myOtp.toString()) {
                          print(otp.text.toString());
                          print(myOtp.toString());
                          Library().alertError(context, "Invalid OTP");
                        } else {
                          sendOtp(postBody);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text('Verify',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Verdana",
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      )),
                ),
              ),
              // Center(
              //   child: Container(
              //     margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              //     child: OutlinedButton(
              //         style: OutlinedButton.styleFrom(
              //           fixedSize: Size.fromWidth(300),
              //           backgroundColor: Color(0xffe9b603),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(50.0),
              //           ),
              //         ),
              //         onPressed: () {
              //           Library().regenerateOtp(context);
              //         },
              //         child: Padding(
              //           padding: EdgeInsets.all(15),
              //           child: Text('Resend Code',
              //               style: TextStyle(
              //                   fontSize: 20,
              //                   fontFamily: "Verdana",
              //                   color: Colors.black,
              //                   fontWeight: FontWeight.bold)),
              //         )),
              //   ),
              // ),
            ],
          ),
        ));
  }

  Future<void> sendOtp(postBody) async {
    Library().loadingDialog(context);
    String pageId = "verification.php";

    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      // Navigator.of(context).pop();

      if (response.statusCode == 200) {
        var resVal = jsonDecode(response.body);
        print(resVal);
        if (resVal[0] == '0') {
          Navigator.pop(context);
          Library().alertError(context, "You are now registered!");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          Navigator.pop(context);
          Library()
              .alertError(context, "Something wen't wrong. Please try again");
        }
      }
    } catch (ex) {
      debugPrint(ex.toString());
      Navigator.pop(context);
      Library().alertError(context, "Something wen't wrong");
    }
  }
}
