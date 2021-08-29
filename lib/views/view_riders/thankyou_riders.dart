import 'package:flutter/material.dart';
import 'package:hatidapp/constants/bottombar.dart';

class ThankyouPage extends StatefulWidget {
  ThankyouPageState createState() => ThankyouPageState();
}

class ThankyouPageState extends State<ThankyouPage> {
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
        height: MediaQuery.of(context).size.height - 200,
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
                  "Thank You",
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
                height: 250,
                margin:
                    EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35.0),
                  child:
                      Image.asset('assets/src/folder.png', fit: BoxFit.contain),
                )),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Text(
                    "Please attach here all the files needed",
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                )),
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
                    onPressed: () {},
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text('Submit',
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
      ),
    );
  }
}
