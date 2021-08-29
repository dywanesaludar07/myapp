import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/constants/bottombar.dart';
import 'package:hatidapp/constants/bottombar_riders.dart';
import 'package:hatidapp/constants/spinkit.dart';
import 'package:hatidapp/views/login_main.dart';
import 'package:hatidapp/views/view_riders/login_main.dart';
import 'package:hatidapp/views/view_riders/profile_viewer.dart';
import 'package:intl/intl_standalone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'login.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as Math;

class ProfilePage extends StatefulWidget {
  ChangeSettingsState createState() => ChangeSettingsState();
}

class ChangeSettingsState extends State<ProfilePage> {
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  String? userId;
  List details = [];
  Widget detailsContainer = Container();
  TextEditingController addressController = new TextEditingController();
  TextEditingController newController = new TextEditingController();
  TextEditingController retypeController = new TextEditingController();
  TextEditingController accountController = new TextEditingController();
  TextEditingController contactController = new TextEditingController();
  bool ch_pass = false;
  bool ch_address = false;
  bool ch_name = false;
  bool ch_contact = false;
  bool obscureConf = true;
  bool obscure = true;
  String account_name = '-';
  String current_address = '-';
  Widget profileContainer = Container();
  String contact = '-';
  File? imageFile;
  @override
  void initState() {
    super.initState();
    detailsContainer = Container(
        width: 30,
        height: 30,
        margin: EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(0),
        child: Spinkit());
    setPref();
  }

  Widget setProfile() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileViewer(Library().url +
                    "dp_person.php/?width=900&url=" +
                    Library().numHash(int.parse(userId!)).toString())));
      },
      child: Container(
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          color: Colors.grey,
          image: DecorationImage(
            image: NetworkImage(Library().url +
                "dp_person.php/?width=900&url=" +
                Library().numHash(int.parse(userId!)).toString()),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(100.0)),
          border: Border.all(
            color: Colors.white,
            width: 3.0,
          ),
        ),
      ),
    );
  }

  Widget fileProfile() {
    return Container(
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
        color: Colors.grey,
        image: DecorationImage(
          image: FileImage(imageFile!),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(Radius.circular(100.0)),
        border: Border.all(
          color: Color(0xff363636),
          width: 3.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff363636),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(0xffe9b603),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.signOutAlt,
                    color: Color(0xff2c2c2c)),
                tooltip: 'Logme Out',
                onPressed: () {
                  showCupertinoDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                            title: Text("E-Hatid App"),
                            content: Text(
                                "Do you really want to leave this application?"),
                            actions: [
                              // Close the dialog
                              CupertinoButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                              CupertinoButton(
                                child: Text('Logout'),
                                onPressed: () {
                                  removePref();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => MainPage()),
                                      (Route<dynamic> route) => false);
                                },
                              )
                            ],
                          ));
                },
              ),
            ]),
        body: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Color(0xffe9b603),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35.0),
                      bottomRight: Radius.circular(35.0)),
                ),
                height: 190,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(children: [
                      profileContainer,
                      Visibility(
                        visible: imageFile != null,
                        child: Positioned(
                          bottom: 0,
                          child: Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  color: Color(0xff363636),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  border: Border.all(
                                    color: Color(0xffe9b603),
                                    width: 1,
                                  )),
                              child: IconButton(
                                  onPressed: () {
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (_) => CupertinoAlertDialog(
                                              title: Text("E-Hatid App"),
                                              content: Text(
                                                  "Do you really want to change your profile photo?"),
                                              actions: [
                                                // Close the dialog
                                                CupertinoButton(
                                                    child: Text('No'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }),
                                                CupertinoButton(
                                                  child: Text('Yes'),
                                                  onPressed: () {
                                                    changeProfile();
                                                  },
                                                )
                                              ],
                                            ));
                                  },
                                  icon: FaIcon(FontAwesomeIcons.check,
                                      color: Colors.white))),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                color: Color(0xff363636),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                                border: Border.all(
                                  color: Color(0xffe9b603),
                                  width: 1,
                                )),
                            child: IconButton(
                                onPressed: () {
                                  _pickImage();
                                },
                                icon: FaIcon(FontAwesomeIcons.camera,
                                    color: Colors.white))),
                      )
                    ]),
                    SizedBox(width: 5, height: 5)
                  ],
                )),
            Visibility(
                visible: !ch_pass && !ch_address && !ch_name && !ch_contact,
                child: Column(
                  children: [
                    ListTile(
                      leading: Image.asset('assets/src/icons8-user-90.png'),
                      title: Text("Account Name",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17)),
                      subtitle: Text(account_name,
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              ch_pass = false;
                              ch_name = true;
                              ch_contact = false;
                              ch_address = false;
                            });
                          },
                          icon: FaIcon(FontAwesomeIcons.cogs,
                              color: Colors.white)),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(left: 10, right: 7),
                        child: Icon(
                          FontAwesomeIcons.phoneAlt,
                          size: 35.0,
                          color: Colors.white,
                        ),
                      ),
                      title: Text("Contact Number",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17)),
                      subtitle: Text(contact,
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              ch_pass = false;
                              ch_name = false;
                              ch_contact = true;
                              ch_address = false;
                            });
                          },
                          icon: FaIcon(FontAwesomeIcons.cogs,
                              color: Colors.white)),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Image.asset('assets/src/drop.png'),
                      title: Text("Current Address",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17)),
                      subtitle: Text(current_address,
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              ch_pass = false;
                              ch_address = true;
                            });
                          },
                          icon: FaIcon(FontAwesomeIcons.cogs,
                              color: Colors.white)),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Image.asset('assets/src/password.png'),
                      title: Text("Change Password",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17)),
                      subtitle: Text(
                        "You can easily modify or change your password here",
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              ch_pass = true;
                              ch_address = false;
                            });
                          },
                          icon: FaIcon(FontAwesomeIcons.cogs,
                              color: Colors.white)),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    // Container(
                    //     margin: EdgeInsets.all(20),
                    //     padding: EdgeInsets.all(20),
                    //     decoration: BoxDecoration(
                    //       border:
                    //           Border.all(color: Colors.grey.shade700, width: 3),
                    //       borderRadius: BorderRadius.circular(15),
                    //       color: Color(0xff2c2c2c),
                    //     ),
                    //     child: Text(
                    //       "Please Note: Only personal account can change their address",
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 15,
                    //           color: Colors.white),
                    //     ))
                  ],
                )),
            Visibility(visible: ch_contact, child: contactWidget()),
            Visibility(visible: ch_name, child: accountWidget()),
            Visibility(visible: ch_address, child: addressWidget()),
            Visibility(visible: ch_pass, child: passWidget())
          ],
        ),
        bottomNavigationBar: BottomBarRiders(3));
  }

  Future<void> changeProfile() async {
    Navigator.pop(context);
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "upload_rider.php";
    String sKey = Library().sKey;

    try {
      var fileNames = imageFile!.path.split("/").last;
      print(fileNames);
      String url = Library().url + "/" + pageId;
      var req = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['fileName'] = Library().numHash(int.parse(userId!)).toString()
        ..fields['updateProfile'] = nonce
        ..fields['sKey'] = sKey
        ..files.add(http.MultipartFile.fromBytes(
            'fileImage', imageFile!.readAsBytesSync(),
            filename: fileNames.toString()));

      var response = await req.send();
      if (response.statusCode == 200) {
        var result = await http.Response.fromStream(response);
        var res = jsonDecode(result.body);
        print("RESULT HERE" + res[0]);
        if (res[0] == "0") {
          Navigator.pop(context);
          setState(() {
            imageFile = null;
            Library().alertError(
                context, "You've successfully changed your profile photo");
          });
        } else {
          Navigator.pop(context);
          Library().alertError(context,
              "Changing of profile encounter some issues please uploading again");
        }
      }
    } catch (ex) {
      print(ex.toString());
      Navigator.pop(context);
      Library().alertError(context,
          "Changing of profile encounter some issues please uploading again");
    }
  }

  Widget contactWidget() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
          padding: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Color(0xff2c2c2c),
            border: Border.all(
                color: Colors.grey, // set border color
                width: 1.0), // set border width
            borderRadius: BorderRadius.all(
                Radius.circular(30.0)), // set rounded corner radius
          ),
          child: TextField(
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Colors.white),
            maxLength: 100,
            controller: contactController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Contact Number',
              counterText: '',
              hintStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
              border: InputBorder.none,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 40, right: 40, top: 15),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: Size.fromWidth(300),
                backgroundColor: Color(0xffe9b603),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                side: BorderSide(width: 1, color: Colors.white),
              ),
              onPressed: () {
                if (contactController.text.isEmpty) {
                  Library().alertError(context, "Field must be fill up");
                } else {
                  updateContactDialog(context);
                }
              },
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text('Save Changes',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Verdana",
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              )),
        ),
        Container(
          margin: EdgeInsets.only(left: 40, right: 40, top: 5),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: Size.fromWidth(300),
                backgroundColor: Color(0xffe9b603),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                side: BorderSide(width: 1, color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  ch_address = false;
                  ch_pass = false;
                  ch_name = false;
                  ch_contact = false;
                  contactController.text = '';
                });
              },
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text('Cancel',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Verdana",
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              )),
        ),
      ],
    );
  }

  Future<Null> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      _cropImage();
    }
  }

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        profileContainer = fileProfile();
      });
    }
  }

  Widget accountWidget() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
          padding: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Color(0xff2c2c2c),
            border: Border.all(
                color: Colors.grey, // set border color
                width: 1.0), // set border width
            borderRadius: BorderRadius.all(
                Radius.circular(30.0)), // set rounded corner radius
          ),
          child: TextField(
            style: TextStyle(color: Colors.white),
            maxLength: 100,
            controller: accountController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Account Name',
              counterText: '',
              hintStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
              border: InputBorder.none,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 40, right: 40, top: 15),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: Size.fromWidth(300),
                backgroundColor: Color(0xffe9b603),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                side: BorderSide(width: 1, color: Colors.white),
              ),
              onPressed: () {
                if (accountController.text.isEmpty) {
                  Library().alertError(context, "Field must be fill up");
                } else {
                  updateDialogAccount(context);
                }
              },
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text('Save Changes',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Verdana",
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              )),
        ),
        Container(
          margin: EdgeInsets.only(left: 40, right: 40, top: 5),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: Size.fromWidth(300),
                backgroundColor: Color(0xffe9b603),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                side: BorderSide(width: 1, color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  ch_name = false;
                  ch_pass = false;
                  accountController.text = '';
                  ch_address = false;
                  ch_contact = false;
                });
              },
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text('Cancel',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Verdana",
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              )),
        ),
      ],
    );
  }

  Widget addressWidget() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
          padding: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Color(0xff2c2c2c),
            border: Border.all(
                color: Colors.grey, // set border color
                width: 1.0), // set border width
            borderRadius: BorderRadius.all(
                Radius.circular(30.0)), // set rounded corner radius
          ),
          child: TextField(
            style: TextStyle(color: Colors.white),
            maxLength: 100,
            controller: addressController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'New Address',
              counterText: '',
              hintStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
              border: InputBorder.none,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 40, right: 40, top: 15),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: Size.fromWidth(300),
                backgroundColor: Color(0xffe9b603),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                side: BorderSide(width: 1, color: Colors.white),
              ),
              onPressed: () {
                if (addressController.text.isEmpty) {
                  Library().alertError(context, "Field must be fill up");
                } else {
                  updateDialogAddress(context);
                }
              },
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text('Save Changes',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Verdana",
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              )),
        ),
        Container(
          margin: EdgeInsets.only(left: 40, right: 40, top: 5),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: Size.fromWidth(300),
                backgroundColor: Color(0xffe9b603),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                side: BorderSide(width: 1, color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  ch_address = false;
                  ch_pass = false;
                  addressController.text = '';
                });
              },
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text('Cancel',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Verdana",
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              )),
        ),
      ],
    );
  }

  Widget passWidget() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
          padding: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Color(0xff2c2c2c),
            border: Border.all(
                color: Colors.grey, // set border color
                width: 1.0), // set border width
            borderRadius: BorderRadius.all(
                Radius.circular(30.0)), // set rounded corner radius
          ),
          child: TextField(
            style: TextStyle(color: Colors.white),
            maxLength: 30,
            controller: newController,
            textAlign: TextAlign.center,
            obscureText: obscureConf,
            decoration: InputDecoration(
              hintText: 'New Password',
              counterText: '',
              contentPadding: EdgeInsets.all(8),
              prefixIcon: FaIcon(FontAwesomeIcons.user,
                  size: 18, color: Colors.transparent),
              suffixIcon: IconButton(
                padding: EdgeInsets.only(bottom: 10),
                icon: obscureConf
                    ? FaIcon(FontAwesomeIcons.eye,
                        color: Colors.white, size: 18)
                    : FaIcon(FontAwesomeIcons.eyeSlash,
                        color: Colors.white, size: 18),
                onPressed: () {
                  setState(() {
                    if (obscureConf) {
                      obscureConf = false;
                    } else {
                      obscureConf = true;
                    }
                  });
                },
              ),
              hintStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
              border: InputBorder.none,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
          padding: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Color(0xff2c2c2c),
            border: Border.all(
                color: Colors.grey, // set border color
                width: 1.0), // set border width
            borderRadius: BorderRadius.all(
                Radius.circular(30.0)), // set rounded corner radius
          ),
          child: TextField(
            controller: retypeController,
            maxLength: 30,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
            obscureText: obscure,
            decoration: InputDecoration(
              counterText: '',
              hintText: 'Re-type Password',
              contentPadding: EdgeInsets.all(8),
              prefixIcon: FaIcon(FontAwesomeIcons.user,
                  size: 18, color: Colors.transparent),
              suffixIcon: IconButton(
                padding: EdgeInsets.only(bottom: 10),
                icon: obscure
                    ? FaIcon(FontAwesomeIcons.eye,
                        color: Colors.white, size: 18)
                    : FaIcon(FontAwesomeIcons.eyeSlash,
                        color: Colors.white, size: 18),
                onPressed: () {
                  setState(() {
                    if (obscure) {
                      obscure = false;
                    } else {
                      obscure = true;
                    }
                  });
                },
              ),
              hintStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
              border: InputBorder.none,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 40, right: 40, top: 15),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: Size.fromWidth(300),
                backgroundColor: Color(0xffe9b603),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                side: BorderSide(width: 1, color: Colors.white),
              ),
              onPressed: () {
                if (newController.text.isEmpty ||
                    retypeController.text.isEmpty) {
                  Library().alertError(context, "All fields must be fill up");
                } else if (validatePassword(newController.text.toString()) !=
                    "0") {
                  Library().alertError(
                      context, validatePassword(newController.text.toString()));
                } else if (newController.text != retypeController.text) {
                  Library().alertError(context, "You passwords do not match");
                } else {
                  updateDialog(context);
                }
              },
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text('Save Changes',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Verdana",
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              )),
        ),
        Container(
          margin: EdgeInsets.only(left: 40, right: 40, top: 5),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: Size.fromWidth(300),
                backgroundColor: Color(0xffe9b603),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                side: BorderSide(width: 1, color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  ch_address = false;
                  ch_pass = false;
                  newController.text = '';
                  retypeController.text = '';
                });
              },
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text('Cancel',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Verdana",
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              )),
        ),
      ],
    );
  }

  String validatePassword(String value) {
    RegExp regex = new RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (!regex.hasMatch(value))
      return 'Password must be 8 characters long and consist of atleast 1 Upper case, Lower case , Special character and a number';
    else
      return "0";
  }

  void updateDialogAddress(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("E-Hatid App"),
              content: Text("Do you really want to change your address?"),
              actions: [
                // Close the dialog
                CupertinoButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                CupertinoButton(
                  child: Text('Yes'),
                  onPressed: () {
                    updateAddress();
                  },
                )
              ],
            ));
  }

  void updateDialogAccount(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("E-Hatid App"),
              content: Text("Do you really want to change your account name?"),
              actions: [
                // Close the dialog
                CupertinoButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                CupertinoButton(
                  child: Text('Yes'),
                  onPressed: () {
                    updateAccountRider();
                  },
                )
              ],
            ));
  }

  void updateContactDialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("E-Hatid App"),
              content: Text(
                  "Do you really want to change the contact number associated in this account?"),
              actions: [
                // Close the dialog
                CupertinoButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                CupertinoButton(
                  child: Text('Yes'),
                  onPressed: () {
                    updateContactRider();
                  },
                )
              ],
            ));
  }

  void updateDialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("E-Hatid App"),
              content: Text("Do you really want to change your password?"),
              actions: [
                // Close the dialog
                CupertinoButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                CupertinoButton(
                  child: Text('Yes'),
                  onPressed: () {
                    updateDetails();
                  },
                )
              ],
            ));
  }

  void showAlertDialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("E-Hatid App"),
              content: Text(
                  "Your password were updated successfully. We are going to log out this account to check the changes you've made"),
              actions: [
                // Close the dialog
                CupertinoButton(
                    child: Text('Not now'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      ch_pass = false;
                    }),
                CupertinoButton(
                  child: Text('Logout'),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginRider()));
                  },
                )
              ],
            ));
  }

  Future<void> updateContactRider() async {
    Navigator.pop(context);
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "rider_details.php";
    String sKey = Library().sKey;

    var postBody = {
      "update_contact": nonce,
      'sKey': sKey,
      'contact_number': contactController.text.toString(),
      'userId': userId.toString(),
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] == '0') {
          setState(() {
            contactController.text = '';
            ch_contact = false;
            Navigator.pop(context);
            getUserDetails();
            Library().alertError(
                context, "Contact number were updated successfully");
          });
        } else {
          Navigator.pop(context);
          Library().alertError(context, "Something wen't wrong");
        }
      }
    } catch (ex) {
      Navigator.pop(context);
      Library().alertError(context, "Something wen't wrong");
    }
  }

  Future<void> updateAccountRider() async {
    Navigator.pop(context);
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "rider_details.php";
    String sKey = Library().sKey;

    var postBody = {
      "update_account": nonce,
      'sKey': sKey,
      'new_account': accountController.text.toString(),
      'userId': userId.toString(),
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] == '0') {
          setState(() {
            accountController.text = '';
            ch_name = false;
            Navigator.pop(context);
            getUserDetails();
            Library()
                .alertError(context, "Account name were updated successfully");
          });
        } else {
          Navigator.pop(context);
          Library().alertError(context, "Something wen't wrong");
        }
      }
    } catch (ex) {
      Navigator.pop(context);
      Library().alertError(context, "Something wen't wrong");
    }
  }

  Future<void> updateAddress() async {
    Navigator.pop(context);
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "rider_details.php";
    String sKey = Library().sKey;

    var postBody = {
      "update_address": nonce,
      'sKey': sKey,
      'address': addressController.text.toString(),
      'userId': userId.toString(),
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] == '0') {
          setState(() {
            addressController.text = '';
            ch_address = false;
            Navigator.pop(context);
            getUserDetails();
            Library().alertError(context, "Address were successfully updated");
          });
        } else {
          Navigator.pop(context);
          Library().alertError(context, "Something wen't wrong");
        }
      }
    } catch (ex) {
      Navigator.pop(context);
      Library().alertError(context, "Something wen't wrong");
    }
  }

  Future<void> updateDetails() async {
    Navigator.pop(context);
    Library().loadingDialog(context);
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "rider_details.php";
    String sKey = Library().sKey;

    var postBody = {
      "update_details": nonce,
      'sKey': sKey,
      'new_password': newController.text.toString(),
      'userId': userId.toString(),
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result[0] == '0') {
          Library().alertError(context, "");
          setState(() {
            newController.text = '';
            retypeController.text = '';
            Navigator.pop(context);
            showAlertDialog(context);
          });
        } else {
          Navigator.pop(context);
          Library().alertError(context, "Something wen't wrong");
        }
      }
    } catch (ex) {
      Navigator.pop(context);
      Library().alertError(context, "Something wen't wrong");
    }
  }

  Future<void> getUserDetails() async {
    String nonce = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String pageId = "rider_details.php";
    String sKey = Library().sKey;

    var postBody = {
      "get_details": nonce,
      'sKey': sKey,
      'userId': userId.toString(),
    };
    print(postBody);
    try {
      String url = Library().url + "/" + pageId;
      http.Response response = await Library().postRequest(url, postBody);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result);
        if (result[0] != '0') {
          setState(() {
            details = result;
            current_address = result[0]['address'];
            account_name = result[0]['account_name'];
            contact = result[0]['contact_number'];
          });
        } else {
          Library().alertError(context, "Something wen't wrong");
        }
      }
    } catch (ex) {
      print(ex.toString());
      Library().alertError(context, "Something wen't wrong");
    }
  }

  void evictImage(url) {
    final NetworkImage provider = NetworkImage(url);
    provider.evict().then<void>((bool success) {
      if (success) debugPrint('removed image!');
    });
  }

  removePref() async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    setState(() {
      setSharedPreds.remove('riderId');
    });
  }

  setPref() async {
    final SharedPreferences setSharedPreds = await sharedPrefs;
    setState(() {
      userId = setSharedPreds.getString('riderId');
      evictImage(Library().url +
          "dp_person.php/?width=900&url=" +
          Library().numHash(int.parse(userId!)).toString());
      profileContainer = setProfile();
    });
    getUserDetails();
  }
}
