import 'package:flutter/material.dart';
import 'package:hatidapp/constants/bottombar.dart';
import 'package:hatidapp/views/view_riders/attach.dart';

class RequirementRider extends StatefulWidget {
  final String name;
  RequirementRider(this.name);
  RequirementRiderState createState() => RequirementRiderState(this.name);
}

class RequirementRiderState extends State<RequirementRider> {
  final String name;
  RequirementRiderState(this.name);
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
                height: 500,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
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
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Official Receipt/Certificate of Registration",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Atleast 1 government ID",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Verified Gcash, Paymaya, and Coins.ph Account",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "21 years old and above",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Up to date driver's license",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "And must be responsible, reliable and able to keep up in a fast work paced environment",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        )),
                    Center(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              fixedSize: Size.fromWidth(300),
                              backgroundColor: Color(0xffe9b603),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AttachPage(name)));
                            },
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text('Proceed',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Verdana",
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            )),
                      ),
                    ),
                  ],
                )))
          ],
        ),
      ),
    );
  }
}
