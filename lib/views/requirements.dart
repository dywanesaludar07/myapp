import 'package:flutter/material.dart';
import 'package:hatidapp/constants/bottombar.dart';

class RequirementsPage extends StatefulWidget {
  RequirementsPageState createState() => RequirementsPageState();
}

class RequirementsPageState extends State<RequirementsPage> {
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
                  "Requirements",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Verdana",
                      color: Color(0xffe9b603),
                      fontSize: 30),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Official Receipt/ Certification of Registration",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
                Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Atleast 1 goverment ID",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Verified Gcash, Paymaya, and Coins.ph Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "21 years old and above",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Up to date driver's license",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "And must be responsible, reliable and able to keep up in a fast work paced environment",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size.fromWidth(300),
                        backgroundColor: Color(0xffe9b603),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        side: BorderSide(width: 1, color: Colors.white),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Proceed',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Verdana",
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(2),
    );
  }
}
