import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/constants/bottombar.dart';
import 'package:hatidapp/views/polylines.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class TrackParcelPage extends StatefulWidget {
  final id;
  final String riderId;
  TrackParcelPage(this.id, this.riderId);
  TrackParcelPageState createState() =>
      TrackParcelPageState(this.id, this.riderId);
}

class TrackParcelPageState extends State<TrackParcelPage> {
  final id;
  final String riderId;
  List notifs = [];
  Widget containerDetails = Container();
  Widget trackerDetails = Container();

  TrackParcelPageState(this.id, this.riderId);
  List details = [];
  String arr = '1';
  String going = '2';
  String finish = '3';
  String riderName = '';
  @override
  void initState() {
    super.initState();
    getDetails();
    notifParcel();
    trackerDetails = Container(
      height: 295,
      padding: EdgeInsets.all(50),
      child: Text("Tracking your parcel. Please wait for a few moments",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
    );
    containerDetails = containerDetails = Center(
      child: SpinKitRotatingCircle(
        color: Colors.white,
        size: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff363636),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff363636),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
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
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Track Parcel",
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
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Request Number# " +
                      Library().numHash(int.parse(id)).toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Verdana",
                      color: Color(0xffe9b603),
                      fontSize: 20),
                ),
              ),
            ),
            trackerDetails,
            containerDetails,
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(1),
    );
  }

  Widget detailsWidget() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xffe9b603),
          border: Border.all(color: Colors.grey.shade700, width: 1),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(35.0),
              bottomRight: Radius.circular(35.0)),
        ),
        height: MediaQuery.of(context).size.height - 600,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 10),
            RawMaterialButton(
              onPressed: () {
                var number = details[0]['contact_number'];
                launcher.launch('tel:$number');
              },
              elevation: 4.0,
              fillColor: Colors.white,
              child: Icon(Icons.phone, size: 35.0, color: Color(0xff363636)),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
            ),
            SizedBox(width: 5),
            Container(
                child: Column(
              children: [
                SizedBox(height: 3),
                Container(
                  width: 90.0,
                  height: 90.0,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xff363636),
                    image: DecorationImage(
                      image: NetworkImage(Library().url +
                          "dp_person.php/?width=900&url=" +
                          Library().numHash(int.parse(riderId)).toString()),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    border: Border.all(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  details[0]['account_name'].split(" ")[0],
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )
              ],
            )),
            SizedBox(width: 5),
            RawMaterialButton(
              onPressed: () {
                var number = details[0]['contact_number'];
                launcher.launch('sms:$number');
              },
              elevation: 4.0,
              fillColor: Colors.white,
              child: Icon(
                Icons.chat_outlined,
                size: 35.0,
                color: Color(0xff363636),
              ),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
            ),
            SizedBox(width: 10),
          ],
        ));
  }

  Widget trackerWidget() {
    return Center(
        child: Container(
      height: 295,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isFirst: true,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color(0xFF27AA69),
              padding: EdgeInsets.all(6),
            ),
            endChild: ListTile(
                leading: Image.network(
                    "https://cdn.iconscout.com/icon/premium/png-512-thumb/order-confirmation-2288866-1908725.png",
                    height: 50,
                    width: 50),
                title: Text("Order Confirmed",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                subtitle: Text("Your order has been confirmed.",
                    style: TextStyle(color: Colors.white))),
            beforeLineStyle: const LineStyle(
              color: Color(0xFF27AA69),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color(0xFF27AA69),
              padding: EdgeInsets.all(6),
            ),
            endChild: ListTile(
                leading: CircleAvatar(
                    backgroundColor: Color(0xff363636),
                    radius: 30,
                    backgroundImage: NetworkImage(
                        "https://png.pngtree.com/png-clipart/20201224/ourlarge/pngtree-courier-png-image_2607466.jpg")),
                title: Text("On going order",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                subtitle: Text("Your order is now on delivery",
                    style: TextStyle(color: Colors.white))),
            beforeLineStyle: const LineStyle(
              color: Color(0xFF27AA69),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: IndicatorStyle(
              width: 20,
              color:
                  notifs.contains(arr) ? Color(0xFF27AA69) : Color(0xFFDADADA),
              padding: EdgeInsets.all(6),
            ),
            endChild: ListTile(
                onTap: () {
                  if (!notifs.contains(arr)) {
                    Library().alertError(
                        context, "Rider is still on his way to pickup point");
                  } else if (notifs.contains(going)) {
                    Library().alertError(
                        context, "Rider were already left the pick up point");
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PolyLines(id,riderName)));
                  }
                },
                leading: CircleAvatar(
                    backgroundColor: Color(0xff363636),
                    radius: 30,
                    backgroundImage: NetworkImage(
                        "https://static.wixstatic.com/media/1170c5_96fb7b961fbc49188638225a3520c32c~mv2.png/v1/fill/w_315,h_315,al_c,lg_1,q_85/Order%20Pickup.webp")),
                title: Text("Pick Up Point",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                subtitle: Text("The rider is now at your pick up point",
                    style: TextStyle(color: Colors.white))),
            beforeLineStyle: LineStyle(
              color:
                  notifs.contains(arr) ? Color(0xFF27AA69) : Color(0xFFDADADA),
            ),
            afterLineStyle: LineStyle(
              color:
                  notifs.contains(arr) ? Color(0xFF27AA69) : Color(0xFFDADADA),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isLast: true,
            indicatorStyle: IndicatorStyle(
              width: 20,
              color: notifs.contains(going)
                  ? Color(0xFF27AA69)
                  : Color(0xFFDADADA),
              padding: EdgeInsets.all(6),
            ),
            endChild: ListTile(
                onTap: () {
                  if (!notifs.contains(going)) {
                    Library().alertError(context,
                        "Maybe the rider is still at the pickup point or on the way his way to drop off point");
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PolyLines(id,riderName)));
                  }
                },
                leading: CircleAvatar(
                  backgroundColor: Color(0xff363636),
                  radius: 30,
                  backgroundImage: NetworkImage(
                      "https://png1.12png.com/19/10/25/SzPaUjQ96S/order-fulfillment-purple-wikimedia-commons-freight-transport-logo.jpg"),
                ),
                title: Text("Going to Drop Off Point",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                subtitle: Text("The rider is on the way to drop off point",
                    style: TextStyle(color: Colors.white))),
            beforeLineStyle: LineStyle(
              color: notifs.contains(going)
                  ? Color(0xFF27AA69)
                  : Color(0xFFDADADA),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isLast: true,
            indicatorStyle: IndicatorStyle(
              width: 20,
              color: notifs.contains(finish)
                  ? Color(0xFF27AA69)
                  : Color(0xFFDADADA),
              padding: EdgeInsets.all(6),
            ),
            endChild: ListTile(
                onTap: () {
                  if (!notifs.contains(finish)) {
                    Library().alertError(context,
                        "Maybe the rider is still going to the drop off point");
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PolyLines(id,riderName)));
                  }
                },
                leading: CircleAvatar(
                  backgroundColor: Color(0xff363636),
                  radius: 30,
                  backgroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQL-W--h0rOf7HG-qMMTchNT_HSq71K96orsMFl58QtYTI4uCFs1FzMPT6O9aoLMIBS_hM&usqp=CAU"),
                ),
                title: Text("Arrive at Drop Off Point",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                subtitle: Text("The rider is now at the drop off point",
                    style: TextStyle(color: Colors.white))),
            beforeLineStyle: LineStyle(
              color: notifs.contains(finish)
                  ? Color(0xFF27AA69)
                  : Color(0xFFDADADA),
            ),
          ),
        ],
      ),
    ));
  }

  Future<void> notifParcel() async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "notify_parcel.php";
    String sKey = Library().sKey;
    var postBody = {
      'notif_parcel': nonce,
      'sKey': sKey,
      'rider_id': riderId.toString(),
      'parcel_id': id.toString(),
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result);
        if (result[0] != "empty") {
          setState(() {
            notifs.clear();
            for (var notif in result) {
              notifs.add(notif['notif_type']);
            }

            trackerDetails = trackerWidget();
          });

          print(notifs);
        } else {
          setState(() {
            containerDetails = Center(
              child: Text("No on going delivery. Choose another",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
            );
          });
        }
      } else {
        Library().alertError(context, "Something wen't wrong");
      }
      // Navigator.of(context).pop();
    } catch (ex) {
      print(ex.toString());
      Library().alertError(context, "Something wen't wrong");
    }
  }

  Future<void> getDetails() async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "rider_details.php";
    String sKey = Library().sKey;
    String tarStr = nonce + pageId + sKey;
    Digest hashTarStr = sha1.convert(utf8.encode(tarStr));
    String encTarStr = base64.encode(utf8.encode(hashTarStr.toString()));

    var postBody = {
      "get_details": nonce,
      'sKey': sKey,
      'id': id.toString(),
      'userId': riderId.toString(),
      "tT": encTarStr,
    };

    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] != "0") {
          setState(() {
            details = result;
            riderName = details[0]['account_name'];
            containerDetails = detailsWidget();
            print(result);
          });
        }
      }
    } catch (ex) {}
  }
}
