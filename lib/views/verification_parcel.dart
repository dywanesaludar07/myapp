import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/constants/bottombar.dart';
import 'package:hatidapp/views/list_parcel.dart';
import 'package:hatidapp/views/send_parcel.dart';

class VerificationParcelPage extends StatefulWidget {
  final otp;
  VerificationParcelPage(this.otp);
  VerificationParcelPageState createState() => VerificationParcelPageState(otp);
}

class VerificationParcelPageState extends State<VerificationParcelPage> {
  final otp;
  VerificationParcelPageState(this.otp);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff363636),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff363636),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListParcelPage()));
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
                  height: 150,
                  margin:
                      EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35.0),
                    child: Image.asset('assets/src/checklist (1).png',
                        fit: BoxFit.contain),
                  )),
              Container(
                margin: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Enter here the code we sent to you regarding to your deliver request.',
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
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  textAlign: TextAlign.center,
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
                      onPressed: () {},
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Verify',
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
        bottomNavigationBar: BottomBar(2));
  }
}
