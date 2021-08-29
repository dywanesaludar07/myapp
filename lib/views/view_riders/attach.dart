import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatidapp/constants/Constants.dart';
import 'package:hatidapp/constants/bottombar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:hatidapp/views/login_main.dart';
import 'package:hatidapp/views/view_riders/login_main.dart';
import 'package:http/http.dart' as http;

class AttachPage extends StatefulWidget {
  final String name;
  AttachPage(this.name);
  AttachPageState createState() => AttachPageState(this.name);
}

class AttachPageState extends State<AttachPage> {
  final String fileName;
  AttachPageState(this.fileName);
  bool _loadingPath = false;
  List<String> filePaths = [];
  List fileNames = [];
  @override
  void initState() {
    super.initState();
  }

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowCompression: true,
    );

    try {
      if (result != null) {
        // File file = File(result.files.single.path!);
        if (fileNames.contains(result.files.single.name)) {
          Library().alertError(context, "File already exist");
        } else {
          fileNames.add(result.files.single.name);
          filePaths.add(result.files.single.path!);
        }

        setState(() => _loadingPath = false);
      } else {
        setState(() => _loadingPath = false);
      }
    } on PlatformException catch (e) {
      Library().alertError(context, "File format not supported");
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff363636),
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff363636),
          leading: IconButton(
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    builder: (_) => CupertinoAlertDialog(
                          title: Text("E-HatidApp"),
                          content:
                              Text("Do you really want quit your application?"),
                          actions: [
                            // Close the dialog
                            CupertinoButton(
                                child: Text('Yes'),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SelectLog()));
                                }),
                            // Close the dialog
                            CupertinoButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ],
                        ));
              },
              icon: FaIcon(FontAwesomeIcons.arrowLeft))),
      body: Container(
        margin: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height - 120,
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
                  "Attach File",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Verdana",
                      color: Color(0xffe9b603),
                      fontSize: 30),
                ),
              ),
            ),
            Builder(
              builder: (BuildContext context) => _loadingPath
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: const CircularProgressIndicator(),
                    )
                  : filePaths.isNotEmpty
                      ? Container(
                          color: Colors.white,
                          padding: const EdgeInsets.only(bottom: 30.0),
                          height: MediaQuery.of(context).size.height * 0.50,
                          child: Scrollbar(
                              child: ListView.separated(
                                  itemCount: filePaths.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(),
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                        leading: fileNames[index]
                                                    .split(".")
                                                    .last ==
                                                "pdf"
                                            ? FaIcon(FontAwesomeIcons.filePdf,
                                                color: Colors.black)
                                            : fileNames[index]
                                                        .split(".")
                                                        .last ==
                                                    "docx"
                                                ? FaIcon(
                                                    FontAwesomeIcons.folder,
                                                    color: Colors.black)
                                                : FaIcon(FontAwesomeIcons.file,
                                                    color: Colors.black),
                                        title: Text(
                                          fileNames[index],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        trailing: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                fileNames
                                                    .remove(fileNames[index]);
                                                filePaths
                                                    .remove(filePaths[index]);
                                              });
                                            },
                                            icon: FaIcon(
                                              FontAwesomeIcons.times,
                                              color: Colors.black,
                                              size: 15,
                                            )));
                                  })),
                        )
                      : const SizedBox(),
            ),
            Visibility(
                visible: filePaths.isEmpty,
                child: GestureDetector(
                    onTap: () {
                      _openFileExplorer();
                    },
                    child: Container(
                        height: 250,
                        margin: EdgeInsets.only(
                            top: 20, left: 10, right: 10, bottom: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35.0),
                          child: Image.asset('assets/src/folder.png',
                              fit: BoxFit.contain),
                        )))),
            Visibility(
                visible: filePaths.isEmpty,
                child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade700, width: 3),
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xff2c2c2c),
                    ),
                    child: Text(
                      "Please Note: You must attach all files needed for this application. Just click the envelop displays on your screen.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    ))),
            SizedBox(height: 10),
            Visibility(
              visible: filePaths.isNotEmpty,
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size.fromWidth(300),
                        backgroundColor: Color(0xffe9b603),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      onPressed: () async {
                        showCupertinoDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                                  title: Text("E-Hatid App"),
                                  content: Text(
                                      "Please double check your files before submitting. Once you've submitted all those files you can't revert it"),
                                  actions: [
                                    // Close the dialog
                                    CupertinoButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          int i = 0;
                                          do {
                                            postFile(
                                                filePaths[i], fileNames[i]);
                                            ++i;
                                          } while (i < filePaths.length);
                                          setState(() {
                                            filePaths = [];
                                            fileNames = [];
                                          });
                                          showCupertinoDialog(
                                              context: context,
                                              builder: (_) =>
                                                  CupertinoAlertDialog(
                                                    title: Text("Thank You!"),
                                                    content: Text(
                                                        "Thank you for registering. Our hiring department will contact you within 28-48 hours to discuss the next steps. We will notify you once we finish our eveluation."),
                                                    actions: [
                                                      // Close the dialog
                                                      CupertinoButton(
                                                          child: Text('OK'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            MainPage()));
                                                          }),
                                                    ],
                                                  ));
                                          return;
                                        }),
                                    CupertinoButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                  ],
                                ));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text('Submit',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Verdana",
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      )),
                ),
              ),
            ),
            Visibility(
              visible: filePaths.isNotEmpty,
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 3),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size.fromWidth(300),
                        backgroundColor: Color(0xffe9b603),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      onPressed: () {
                        _openFileExplorer();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text('Choose Another',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Verdana",
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  postFile(path, name) async {
    String pageId = 'send_file.php';
    String url = Library().url + "/" + pageId;
    try {
      var req = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['folder_name'] = fileName.toString()
        ..files.add(http.MultipartFile.fromBytes(
            'filePdf', File(path).readAsBytesSync(),
            filename: name));

      var response = await req.send();

      if (response.statusCode == 200) {
        var result = await http.Response.fromStream(response);
        var res = jsonDecode(result.body);
        if (res[0] == "0") {
          return 0;
        } else {
          return 1;
        }
      } else {
        return 2;
      }
    } catch (ex) {
      print(ex.toString());
    }
  }
}
