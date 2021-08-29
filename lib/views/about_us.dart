import 'package:flutter/material.dart';
import 'package:hatidapp/constants/bottombar.dart';

class AboutPage extends StatefulWidget {
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
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
        child: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "About Us",
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
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color(0xff2c2c2c) // set rounded corner radius
                        ),
                    child: Text(
                      "E-Hatid is courier services that offers fast,reliable and convinient transactions. E-Hatid's technology is designed to put control on everything. It gives you freedom to book a courier anytime",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "OUR MISSION",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Verdana",
                          color: Color(0xffe9b603),
                          fontSize: 20),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Color(0xff2c2c2c), // set rounded corner radius
                    ),
                    child: Text(
                      "Our mission is to be a leader in the industry providing an affordable services which in result will help customer to expand and grow",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "OUR VISION",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Verdana",
                          color: Color(0xffe9b603),
                          fontSize: 20),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Color(0xff2c2c2c), // set rounded corner radius
                    ),
                    child: Text(
                      "To be the best courier services who can offers fast, reliable, and convinient transactions",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 30),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Our Services",
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
                    margin: EdgeInsets.only(top: 40),
                    decoration: BoxDecoration(
                      color: Color(0xff2c2c2c), // set rounded corner radius
                    ),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Express Delivery",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xffe9b603),
                                  fontWeight: FontWeight.bold),
                            )))),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Color(0xff2c2c2c), // set rounded corner radius
                    ),
                    child: Text(
                      "We can handle anything you need. This will provide same day door to door delivery",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 40),
                    decoration: BoxDecoration(
                      color: Color(0xff2c2c2c), // set rounded corner radius
                    ),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Send Parcel",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xffe9b603),
                                  fontWeight: FontWeight.bold),
                            )))),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Color(0xff2c2c2c), // set rounded corner radius
                    ),
                    child: Text(
                      "Book and wait for the rider to drop at your location",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 40),
                    decoration: BoxDecoration(
                      color: Color(0xff2c2c2c), // set rounded corner radius
                    ),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Track Your Parcel",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xffe9b603),
                                  fontWeight: FontWeight.bold),
                            )))),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Color(0xff2c2c2c), // set rounded corner radius
                    ),
                    child: Text(
                      "This will let you know where and when your package will going to arrive to the destination you've set",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 40),
                    decoration: BoxDecoration(
                      color: Color(0xff2c2c2c), // set rounded corner radius
                    ),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Prices/Affordable Rates",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xffe9b603),
                                  fontWeight: FontWeight.bold),
                            )))),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Color(0xff2c2c2c), // set rounded corner radius
                    ),
                    child: Text(
                      "Sending packages with E-Hatid is quick and easy. The price you say depends on the distance of your dropping place",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
              ],
            ))),
      ),
      bottomNavigationBar: BottomBar(3),
    );
  }
}
