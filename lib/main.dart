import 'package:flutter/material.dart';
import 'package:hatidapp/views/about_us.dart';
import 'package:hatidapp/views/change_settings.dart';
import 'package:hatidapp/views/forgot.dart';
import 'package:hatidapp/views/gcash.dart';
import 'package:hatidapp/views/home.dart';
import 'package:hatidapp/views/index.dart';
import 'package:hatidapp/views/list_parcel.dart';
import 'package:hatidapp/views/location.dart';
import 'package:hatidapp/views/login.dart';
import 'package:hatidapp/views/login_main.dart';
import 'package:hatidapp/views/map.dart';
import 'package:hatidapp/views/notifications.dart';
import 'package:hatidapp/views/paypal.dart';
import 'package:hatidapp/views/polylines.dart';
import 'package:hatidapp/views/send_parcel.dart';
import 'package:hatidapp/views/signup.dart';
import 'package:hatidapp/views/track_parcel.dart';
import 'package:hatidapp/views/verification.dart';
import 'package:hatidapp/views/verification_parcel.dart';
import 'package:hatidapp/views/view_riders/attach.dart';
import 'package:hatidapp/views/view_riders/completion.dart';
import 'package:hatidapp/views/view_riders/file_pick.dart';
import 'package:hatidapp/views/view_riders/login_main.dart';
import 'package:hatidapp/views/view_riders/ongoin_parcel.dart';
import 'package:hatidapp/views/view_riders/profile.dart';
import 'package:hatidapp/views/view_riders/request_page.dart';
import 'package:hatidapp/views/view_riders/riders_requirement.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/view_riders/login.dart';

void main() {
  runApp(MyApp());
}

Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String? userId = '';
  bool isRider = false;
  bool isNew = false;
  String? isTutorial = '';
  @override
  void initState() {
    super.initState();
    getPreference();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isTutorial == ''
          ? IndexPage()
          : isNew
              ? MainPage()
              : !isRider
                  ? userId == ''
                      ? LoginPage()
                      : SendParcel()
                  : userId == ''
                      ? LoginRider()
                      : RequestPage(),
    );
  }

  void getPreference() async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    if (setSharedPreds.containsKey('deviceId')) {
      setState(() {
        isTutorial = setSharedPreds.getString('deviceId');
      });
    } else {
      setState(() {
        isTutorial = '';
      });
    }

    if (setSharedPreds.containsKey('userId')) {
      setState(() {
        userId = setSharedPreds.getString('userId');
        isRider = false;
      });
    } else if (setSharedPreds.containsKey('riderId')) {
      setState(() {
        userId = setSharedPreds.getString('riderId');
        isRider = true;
      });
    } else {
      setState(() {
        isNew = true;
        userId = '';
      });
    }
    print(userId);
  }
}
