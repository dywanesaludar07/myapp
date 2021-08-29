import 'package:flutter/material.dart';
import 'package:hatidapp/views/change_settings.dart';
import 'package:hatidapp/views/home.dart';
import 'package:hatidapp/views/list_parcel.dart';
import 'package:hatidapp/views/send_parcel.dart';
import 'package:hatidapp/views/track_parcel.dart';
import 'package:badges/badges.dart';

class BottomBar extends StatelessWidget {
  final currentIndex;
  BottomBar(this.currentIndex);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.grey, spreadRadius: 3, blurRadius: 0),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            onTap: (int index) {
              if (index == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SendParcel()));
              } else if (index == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListParcelPage()));
              } else if (index == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangeSettings()));
              } else if (index == 3) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              }
            },
            currentIndex: currentIndex,
            backgroundColor: Color(0xff2c2c2c),
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedItemColor: Colors.amber[800],
            unselectedItemColor: Colors.white,
            showUnselectedLabels: true,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/src/send_parcel.png'),
                    size: 50),
                label: 'Send Parcel',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                    AssetImage('assets/src/icons8-track-order-100.png'),
                    size: 50),
                label: 'Track Parcel',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/src/icons8-user-90.png'),
                    size: 50),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                      AssetImage('assets/src/icons8-follow-each-other-96.png'),
                      size: 50),
                  label: 'Others'),
            ],
          ),
        ));
  }
}

  // icon: Badge(
                  //   position: BadgePosition.topEnd(top: 0, end: 3),
                  //   animationDuration: Duration(milliseconds: 300),
                  //   animationType: BadgeAnimationType.slide,
                  //   badgeContent: Text(
                  //     "10",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  //   child: ImageIcon(
                  //       AssetImage(
                  //           'assets/src/icons8-follow-each-other-96.png'),
                  //       size: 50),
                  // ),),