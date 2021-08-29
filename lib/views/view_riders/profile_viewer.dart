import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/views/view_riders/ongoin_parcel.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileViewer extends StatefulWidget {
  final String url;
  ProfileViewer(this.url);

  PageViewState createState() => PageViewState(this.url);
}

class PageViewState extends State<ProfileViewer> {
  String url;
  PageViewState(this.url);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: Color(0xff363636),
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Hero(
            tag: 'Profile',
            child: PhotoView(
              filterQuality: FilterQuality.high,
              enableRotation: false,
              imageProvider: NetworkImage(url),
            ),
          )),
    );
  }
}
