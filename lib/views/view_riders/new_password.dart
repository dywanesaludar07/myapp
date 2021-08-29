import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/views/login.dart';
import 'package:hatidapp/views/send_parcel.dart';
import 'package:hatidapp/views/signup.dart';
import 'package:hatidapp/views/view_riders/login.dart';
import 'package:http/http.dart' as http;

class NewPasswordRider extends StatefulWidget {
  final email;
  NewPasswordRider(this.email);
  NewPasswordState createState() => NewPasswordState(this.email);
}

class NewPasswordState extends State<NewPasswordRider> {
  final email;
  NewPasswordState(this.email);

  TextEditingController passwordController = new TextEditingController();
  bool obscure = false;
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
                    "New Password",
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
                    'Set up your new password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 20),
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
                  controller: passwordController,
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
                        if (passwordController.text.toString() == '') {
                          Library().alertError(
                              context, 'All information must be filled up');
                        } else if (validatePassword(
                                passwordController.text.toString()) !=
                            "0") {
                          Library().alertError(
                              context,
                              validatePassword(
                                  passwordController.text.toString()));
                        } else {
                          showAlertDialog(context);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text('Create password',
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

  void showAlertDialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("E-Hatid App"),
              content: Text("Please click register to continue"),
              actions: [
                // Close the dialog
                CupertinoButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                CupertinoButton(
                  child: Text('Register'),
                  onPressed: () {
                    createUser();
                  },
                )
              ],
            ));
  }

  Future<void> createUser() async {
    Navigator.pop(context);
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "new_password.php";
    String sKey = Library().sKey;
    String tarStr = nonce + pageId + sKey;
    Digest hashTarStr = sha1.convert(utf8.encode(tarStr));
    String encTarStr = base64.encode(utf8.encode(hashTarStr.toString()));

    var postBody = {
      "password_rider": nonce,
      "email": email.toString(),
      'password': passwordController.text.toString(),
      'sKey': sKey,
      "tT": encTarStr,
    };

    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result[0] == "0") {
          Navigator.pop(context);
          Library().alertError(
              context, "You have successfully changed your password");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginRider()));
        } else {
          Navigator.pop(context);
          Library().alertError(context,
              "There's a problem creating your password. Please try again");
        }
      }
    } catch (ex) {
      Navigator.pop(context);
      Library().alertError(context, "Something went wrong");
    }
  }

  String validatePassword(String value) {
    RegExp regex = new RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (!regex.hasMatch(value))
      return 'Password must be 8 characters long and consist of atleast 1 Upper case, Lower case , Special character and a number';
    else
      return "0";
  }
}
