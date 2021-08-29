import 'package:flutter/material.dart';
import 'package:hatidapp/views/login.dart';
import 'package:hatidapp/views/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as Math;

class MainPage extends StatefulWidget {
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    setDevice();
  }

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
                  margin: EdgeInsets.all(30),
                  child: Center(
                    child: Text(
                      "Welcome to Ehatid",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Verdana",
                          color: Color(0xffe9b603),
                          fontSize: 45),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Center(
                    child: Text(
                      "Decide when and where, We just follow",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Verdana",
                          color: Color(0xffe9b603),
                          fontSize: 15),
                    ),
                  )),
              SizedBox(
                height: 100,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size.fromWidth(300),
                      backgroundColor: Color(0xffe9b603),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      side: BorderSide(width: 1),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Log In',
                          style: TextStyle(
                              fontSize: 19,
                              fontFamily: "Verdana",
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    )),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size.fromWidth(300),
                      backgroundColor: Color(0xff2c2c2c),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      side: BorderSide(width: 1, color: Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Sign Up',
                          style: TextStyle(
                              fontSize: 19,
                              fontFamily: "Verdana",
                              color: Color(0xffe9b603),
                              fontWeight: FontWeight.bold)),
                    )),
              )
            ],
          ),
        ));
  }

  void setDevice() async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    setState(() {
      setSharedPreds.setString('deviceId', Math.Random().toString());
    });
  }
}
