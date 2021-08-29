import 'dart:async';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/views/verification.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/views/login.dart';
import 'package:toast/toast.dart';
import 'package:flutter/cupertino.dart';

class SignUpPage extends StatefulWidget {
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  String accountType = 'Personal';

  TextEditingController nameController = new TextEditingController();
  TextEditingController contactController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  bool obscureConf = true;
  bool obscure = true;
  int? groupValue = 0;

  void _handleValue(int? value) {
    setState(() {
      groupValue = value;
      print(groupValue);
    });
  }

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
                margin: EdgeInsets.all(15),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "Sign Up",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Verdana",
                        color: Color(0xffe9b603),
                        fontSize: 45),
                  ),
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xff2c2c2c),
                  border: Border.all(
                      color: Colors.grey, // set border color
                      width: 1.0), // set border width
                  borderRadius: BorderRadius.all(
                      Radius.circular(30.0)), // set rounded corner radius
                ),
                child: TextField(
                  maxLength: 30,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  controller: nameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    hintText: 'Name',
                    counterText: '',
                    hintStyle: TextStyle(
                        fontSize: 17.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: Radio(
                        splashRadius: 15,
                        focusColor: Colors.white,
                        value: 0,
                        groupValue: groupValue,
                        onChanged: _handleValue,
                        activeColor: Color(0xffe9b603)),
                  ),
                  new Text(
                    'Personal Account',
                    style: new TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: Radio(
                      value: 1,
                      splashRadius: 15,
                      focusColor: Colors.white,
                      groupValue: groupValue,
                      onChanged: _handleValue,
                      activeColor: Color(0xffe9b603),
                    ),
                  ),
                  new Text(
                    'Business',
                    style: new TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                height: 50,
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xff2c2c2c),
                  border: Border.all(
                      color: Colors.grey, // set border color
                      width: 1.0), // set border width
                  borderRadius: BorderRadius.all(
                      Radius.circular(30.0)), // set rounded corner radius
                ),
                child: TextField(
                  maxLength: 12,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  controller: contactController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    hintText: 'Contact Number',
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
                height: 50,
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xff2c2c2c),
                  border: Border.all(
                      color: Colors.grey, // set border color
                      width: 1.0), // set border width
                  borderRadius: BorderRadius.all(
                      Radius.circular(30.0)), // set rounded corner radius
                ),
                child: TextField(
                  maxLength: 30,
                  obscureText: false,
                  controller: emailController,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    counterText: '',
                    hintText: 'Email',
                    hintStyle: TextStyle(
                        fontSize: 17.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xff2c2c2c),
                  border: Border.all(
                      color: Colors.grey, // set border color
                      width: 1.0), // set border width
                  borderRadius: BorderRadius.all(
                      Radius.circular(30.0)), // set rounded corner radius
                ),
                child: TextField(
                  obscureText: false,
                  controller: addressController,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    counterText: '',
                    hintText: 'Address',
                    hintStyle: TextStyle(
                        fontSize: 17.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xff2c2c2c),
                  border: Border.all(
                      color: Colors.grey, // set border color
                      width: 1.0), // set border width
                  borderRadius: BorderRadius.all(
                      Radius.circular(30.0)), // set rounded corner radius
                ),
                child: TextField(
                  maxLength: 30,
                  controller: passwordController,
                  obscureText: obscure,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.all(8),
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
              Container(
                height: 50,
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xff2c2c2c),
                  border: Border.all(
                      color: Colors.grey, // set border color
                      width: 1.0), // set border width
                  borderRadius: BorderRadius.all(
                      Radius.circular(30.0)), // set rounded corner radius
                ),
                child: TextField(
                  maxLength: 30,
                  controller: confirmController,
                  obscureText: obscureConf,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.all(8),
                    suffixIcon: IconButton(
                      padding: EdgeInsets.only(bottom: 10),
                      icon: obscureConf
                          ? FaIcon(FontAwesomeIcons.eye,
                              color: Colors.white, size: 17)
                          : FaIcon(FontAwesomeIcons.eyeSlash,
                              color: Colors.white, size: 17),
                      onPressed: () {
                        setState(() {
                          if (obscureConf) {
                            obscureConf = false;
                          } else {
                            obscureConf = true;
                          }
                        });
                      },
                    ),
                    hintText: 'Confirm Password',
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
                        if (passwordController.text.toString() !=
                            confirmController.text.toString()) {
                          Library().alertError(
                              context, 'Your passwords do not match');
                        } else if (nameController.text.toString() == '' ||
                            confirmController.text.toString() == '' ||
                            emailController.text.toString() == '' ||
                            addressController.text.toString() == '') {
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
                        padding: EdgeInsets.all(10),
                        child: Text('Register',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Verdana",
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      )),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {},
                      child: Text("Already have an account?",
                          style: TextStyle(
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
                                builder: (context) => LoginPage()));
                      },
                      child: Text("Log In",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffe9b603)))),
                ],
              )
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

  String validatePassword(String value) {
    RegExp regex = new RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (!regex.hasMatch(value))
      return 'Password must be 8 characters long and consist of atleast 1 Upper case, Lower case , Special character and a number';
    else
      return "0";
  }

  Future<void> createUser() async {
    Navigator.pop(context);
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "email_blasting/signup.php";
    String sKey = Library().sKey;
    String tarStr = nonce + pageId + sKey;
    Digest hashTarStr = sha1.convert(utf8.encode(tarStr));
    String encTarStr = base64.encode(utf8.encode(hashTarStr.toString()));

    var postBody = {
      "createUser": nonce,
      'name': nameController.text.toString(),
      'contact': contactController.text.toString(),
      'email': emailController.text.toString(),
      'address': addressController.text.toString(),
      'password': passwordController.text.toString(),
      'confirm': confirmController.text.toString(),
      'groupValue': groupValue.toString(),
      "tT": encTarStr,
    };

    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      // Navigator.of(context).pop();

      if (response.statusCode == 200) {
        var resVal = jsonDecode(response.body);
        print(resVal);
        if (resVal[0] != '1' && resVal[0] != '3') {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => VerificationPage(postBody, resVal[0])));
        } else if (resVal[0] == '3') {
          Navigator.pop(context);
          Library().alertError(context,
              'Email address is already in use. Please choose another');
        } else {
          Navigator.pop(context);
          Library().alertError(context, "Something wen't wrong");
        }
      }
    } catch (ex) {
      debugPrint(ex.toString());
      Navigator.pop(context);
      Library().alertError(context, "Something wen't wrong");
    }
  }
}
