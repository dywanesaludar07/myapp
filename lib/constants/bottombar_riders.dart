import 'package:flutter/material.dart';
import 'package:hatidapp/views/change_settings.dart';
import 'package:hatidapp/views/home.dart';
import 'package:hatidapp/views/list_parcel.dart';
import 'package:hatidapp/views/send_parcel.dart';
import 'package:hatidapp/views/track_parcel.dart';
import 'package:hatidapp/views/view_riders/completion.dart';
import 'package:hatidapp/views/view_riders/ongoin_parcel.dart';
import 'package:hatidapp/views/view_riders/profile.dart';
import 'package:hatidapp/views/view_riders/request_page.dart';

class BottomBarRiders extends StatelessWidget {
  final currentIndex;
  BottomBarRiders(this.currentIndex);
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
                    MaterialPageRoute(builder: (context) => RequestPage()));
              } else if (index == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OnGoingPage()));
              } else if (index == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CompletionPage()));
              } else if (index == 3) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
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
                icon: ImageIcon(
                    AssetImage(
                        'assets/src/icons8-connectivity-and-help-100.png'),
                    size: 50),
                label: 'Requests',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/src/icons8-process-100.png'),
                    size: 50),
                label: 'Ongoing Parcel',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                    AssetImage('assets/src/icons8-check-all-96.png'),
                    size: 50),
                label: 'Completion',
              ),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/src/icons8-user-90.png'),
                      size: 50),
                  label: 'Profile'),
            ],
          ),
        ));
  }
}
