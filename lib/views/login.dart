import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/views/forgot.dart';
import 'package:hatidapp/views/home.dart';
import 'package:hatidapp/views/send_parcel.dart';
import 'package:hatidapp/views/signup.dart';
import 'package:hatidapp/views/view_riders/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool obscure = true;
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff363636),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
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
                  alignment: Alignment.topRight,
                  child: Text(
                    "Log In",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Verdana",
                        color: Color(0xffe9b603),
                        fontSize: 45),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
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
                  maxLength: 30,
                  controller: email,
                  decoration: InputDecoration(
                    hintText: 'Email',
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
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xff2c2c2c),
                  border: Border.all(
                      color: Colors.grey, // set border color
                      width: 1.0), // set border width
                  borderRadius: BorderRadius.all(
                      Radius.circular(30.0)), // set rounded corner radius
                ),
                child: TextField(
                  controller: password,
                  style: TextStyle(fontSize: 17, color: Colors.white),
                  maxLength: 30,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    counterText: '',
                    suffixIcon: IconButton(
                      padding: EdgeInsets.only(bottom: 10),
                      icon: obscure
                          ? FaIcon(FontAwesomeIcons.eye,
                              color: Colors.white, size: 17)
                          : FaIcon(FontAwesomeIcons.eyeSlash,
                              color: Colors.white, size: 17),
                      onPressed: () {
                        setState(() {
                          if (obscure) {
                            obscure = false;
                          } else {
                            obscure = true;
                          }
                        });
                      },
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                        fontSize: 17.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ForgotPage()));
                },
                child: Center(
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10),
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
                        if (email.text.toString() == '' ||
                            password.text.toString() == '') {
                          Library().alertError(
                              context, 'Please complete the credentials');
                        } else {
                          logMeIn();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text('Log In',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Verdana",
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      )),
                ),
              ),
              Row(children: <Widget>[
                SizedBox(width: 30),
                Expanded(
                    child: Divider(
                  color: Colors.white,
                )),
                SizedBox(width: 10),
                Text("OR",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Expanded(
                    child: Divider(
                  color: Colors.white,
                )),
                SizedBox(width: 30),
              ]),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     GestureDetector(
              //       onTap: () {},
              //       child: Image.asset(
              //         'assets/src/fb.png',
              //         height: 50,
              //         width: 50,
              //       ),
              //     ),
              //     SizedBox(
              //       width: 10,
              //     ),
              //     GestureDetector(
              //       onTap: () {},
              //       child: Image.asset(
              //         'assets/src/gmail.png',
              //         height: 50,
              //         width: 50,
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {},
                      child: Text("New User? ",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  SizedBox(
                    width: 1,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: Text("Sign up here",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffe9b603)))),
                ],
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginRider()));
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade700, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff2c2c2c),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bike_scooter, size: 18, color: Colors.white),
                      SizedBox(
                        width: 3,
                      ),
                      Text("I'm an Ehatid Rider!",
                          style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> logMeIn() async {
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "login.php";
    String sKey = Library().sKey;
    String tarStr = nonce + pageId + sKey;
    Digest hashTarStr = sha1.convert(utf8.encode(tarStr));
    String encTarStr = base64.encode(utf8.encode(hashTarStr.toString()));

    var postBody = {
      "loginUser": nonce,
      'sKey': sKey,
      'email': email.text.toString(),
      'password': password.text.toString(),
      "tT": encTarStr,
    };

    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      // Navigator.of(context).pop();

      if (response.statusCode == 200) {
        var resVal = jsonDecode(response.body);
        print(resVal);
        if (resVal[0] != 'err_no') {
          setPref(resVal[0]).then((value) => {
                if (value == "0")
                  {
                    Navigator.pop(context),
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SendParcel()))
                  }
              });
        } else {
          Navigator.pop(context);
          Library().alertError(context, 'Invalid username or password');
        }
      }
    } catch (ex) {
      Navigator.pop(context);
      Library().alertError(context,
          "Something wen't wrong. Your internet connection is not stable. Issue may cause invalid connection to our server");
      debugPrint(ex.toString());
    }
  }

  setPref(userId) async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    setSharedPreds.setString('userId', userId.toString());
    return "0";
  }
}
