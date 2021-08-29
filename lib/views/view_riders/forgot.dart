import 'dart:convert';
import 'package:hatidapp/views/verification_forgot.dart';
import 'package:hatidapp/views/view_riders/verification_forgot.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hatidapp/constants/Constants.dart';

class ForgotPageRider extends StatefulWidget {
  ForgotPageState createState() => ForgotPageState();
}

class ForgotPageState extends State<ForgotPageRider> {
  String otp = '';
  TextEditingController emailController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                    "Forgot Password?",
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
                    child: Image.asset('assets/src/password.png',
                        fit: BoxFit.contain),
                  )),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Enter the email address associated with your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 20),
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
                  controller: emailController,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
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
                        forgot();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text('Send',
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
        ));
  }

  Future<void> forgot() async {
    Library().loadingDialog(context);
    String pageId = "email_blasting/forgot_otp.php";

    var postBody = {
      'email': emailController.text.toString(),
    };

    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      // Navigator.of(context).pop();

      if (response.statusCode == 200) {
        var resVal = jsonDecode(response.body);
        print(resVal);
        if (resVal[0] != '1') {
          Navigator.pop(context);
          setState(() {
            otp = resVal[0].toString();
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      VerificationForgotRider(emailController.text, otp)));
        } else {
          Navigator.pop(context);
          Library().alertError(context,
              "We encounter some problem sending you an otp. Please try again");
        }
      }
    } catch (ex) {
      Library().alertError(context, "Something wen't wrong");
      debugPrint(ex.toString());
    }
  }
}
