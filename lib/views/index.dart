import 'package:flutter/material.dart';
import 'package:hatidapp/views/login_main.dart';
import 'package:page_transition/page_transition.dart';

class IndexPage extends StatefulWidget {
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  Widget bodyPage = Container();
  int slides = 0;
  @override
  void didChangeDependencies() {
    bodyPage = slide1('assets/src/register.png', 'Register',
        'Fill the Registration Form', 'Next');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff363636),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff363636),
        ),
        body: bodyPage);
  }

  Widget slide1(
      String image, String titleImage, String bodyText, String btnText) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.all(20),
            height: 400,
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
                Container(
                    height: 300,
                    margin: EdgeInsets.only(
                        top: 20, left: 10, right: 10, bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35.0),
                      child: Image.asset(image, fit: BoxFit.contain),
                    )),
                Center(
                  child: Text(
                    titleImage,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 20),
                  ),
                ),
              ],
            )),
        Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: Center(
              child: Text(
                bodyText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 20),
              ),
            )),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  fixedSize: Size.fromWidth(120),
                  backgroundColor: Color(0xff2c2c2c),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  side: BorderSide(width: 1, color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MainPage()));
                  // setState(() {
                  //   if (slides == 0) {
                  //     bodyPage = slide1(
                  //         'assets/src/help.png',
                  //         'Fill the Request Form',
                  //         'Fill and ask help from our Ehatid Riders',
                  //         'Next');
                  //   } else if (slides == 1) {
                  //     bodyPage = slide1(
                  //         'assets/src/debit-card.png',
                  //         'Pay',
                  //         "Choose payment method you're comfortable with",
                  //         'Next');
                  //   } else if (slides == 2) {
                  //     bodyPage = slide1(
                  //         'assets/src/relax.png',
                  //         'Wait and Relax',
                  //         'Wait and Relax! Let your Ehatid Rider do the work',
                  //         'Proceed');
                  //   } else if (slides == 3) {
                  //     Navigator.pushReplacement(
                  //       context,
                  //       PageTransition(
                  //         type: PageTransitionType.rightToLeft,
                  //         child: MainPage(),
                  //       ),
                  //     );
                  //   }
                  //   ++slides;
                  // });
                },
                child: Text('Skip',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xffe9b603),
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                width: 20,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  fixedSize: Size.fromWidth(120),
                  backgroundColor: Color(0xffe9b603),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  side: BorderSide(width: 1, color: Colors.grey),
                ),
                onPressed: () {
                  setState(() {
                    if (slides == 0) {
                      bodyPage = slide1(
                          'assets/src/help.png',
                          'Fill the Request Form',
                          'Fill and ask help from our Ehatid Riders',
                          'Next');
                    } else if (slides == 1) {
                      bodyPage = slide1(
                          'assets/src/debit-card.png',
                          'Pay',
                          "Choose payment method you're comfortable with",
                          'Next');
                    } else if (slides == 2) {
                      bodyPage = slide1(
                          'assets/src/relax.png',
                          'Wait and Relax',
                          'Wait and Relax! Let your Ehatid Rider do the work',
                          'Proceed');
                    } else if (slides == 3) {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: MainPage(),
                        ),
                      );
                    }
                    ++slides;
                  });
                },
                child: Text(btnText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
        )
      ],
    );
  }
}
