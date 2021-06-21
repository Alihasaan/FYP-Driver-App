import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ots_driver_app/AuthService.dart';
import 'package:ots_driver_app/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ots_driver_app/Screens/InfoForm.dart';
import 'package:ots_driver_app/utilities/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AccountPage extends StatefulWidget {
  DatabaseReference refDB;

  AccountPage({required this.refDB, Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late DataSnapshot dataResult;

  // ignore: avoid_init_to_null
  File? _image;
  bool imgSelected = false;
  final ImagePicker _picker = ImagePicker();
  bool uploadingImg = false;
  Widget imgShow() {
    return FirebaseAuth.instance.currentUser!.photoURL == null
        ? CircleAvatar(
            radius: 73,
            child: ClipOval(
              child: SizedBox(
                  width: 150,
                  height: 150,
                  child: _image == null
                      ? Image.network(
                          "https://cdn2.iconfinder.com/data/icons/avatars-99/62/avatar-370-456322-512.png",
                          fit: BoxFit.fill,
                        )
                      : Image.file(File(_image!.path), fit: BoxFit.cover)),
            ),
          )
        : CircleAvatar(
            radius: 73,
            child: ClipOval(
                child: SizedBox(
              width: 150,
              height: 150,
              child: Image.network(
                FirebaseAuth.instance.currentUser!.photoURL.toString(),
                fit: BoxFit.fill,
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image;
      try {
        image = await _picker.getImage(source: ImageSource.gallery);
      } catch (e) {
        print(e);
      }
      setState(() {
        _image = File(image!.path);
        imgSelected = true;
        print(_image!.path);
      });
    }

    Future uploadPic(BuildContext context) async {
      String fileName = basename(_image!.path);
      print(fileName);

      Reference imageStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = imageStorageRef.putFile(_image!);
      uploadTask.catchError((e) {
        print(e);
      });
      uploadTask.then((res) {
        res.ref.getDownloadURL().then((value) =>
            FirebaseAuth.instance.currentUser!.updateProfile(photoURL: value));
        print(res.ref.getDownloadURL());

        Fluttertoast.showToast(msg: "Image Updated Successfully!");
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 35,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text("Your Account",
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontSize: 27.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      )),
                ),
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 70,
                width: 370),
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 10, color: primary),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: imgSelected == false
                            ? imgShow()
                            : SizedBox(
                                width: 150,
                                height: 150,
                                child: Image.file(File(_image!.path),
                                    fit: BoxFit.cover),
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.add_a_photo,
                          size: 30,
                          color: primary,
                        ),
                        onPressed: () {
                          getImage();
                        },
                      ),
                    ),
                  ),
                  FutureBuilder(
                      future: widget.refDB
                          .child('Drivers')
                          .child(FirebaseAuth.instance.currentUser!.uid)
                          .once()
                          .then((result) {
                        setState(() {
                          dataResult = result;
                        });
                        return result;
                      }),
                      builder: (context, snapshot) {
                        return Container(
                          padding: EdgeInsets.only(bottom: 100),
                          child: snapshot.hasData
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Text("Driver",
                                          style: TextStyle(
                                            color: Colors.lightGreen,
                                            letterSpacing: 1.5,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                          )),
                                    ),
                                    Container(
                                      child: Text(
                                          dataResult.value["driver_name"]
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.black38,
                                            letterSpacing: 1.5,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                          )),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text("Phone Number:",
                                                style: TextStyle(
                                                  color: Colors.lightGreen,
                                                  letterSpacing: 1.5,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'OpenSans',
                                                )),
                                          ),
                                          Container(
                                            child: Text(
                                                dataResult
                                                    .value["driver_phone"],
                                                style: TextStyle(
                                                  color: Colors.black38,
                                                  letterSpacing: 1.5,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'OpenSans',
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text("CNIC:",
                                                style: TextStyle(
                                                  color: Colors.lightGreen,
                                                  letterSpacing: 1.5,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'OpenSans',
                                                )),
                                          ),
                                          Container(
                                            child: Text(
                                                dataResult.value["driver_CNIC"],
                                                style: TextStyle(
                                                  color: Colors.black38,
                                                  letterSpacing: 1.5,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'OpenSans',
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        );
                      }),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            _image == null
                ? SizedBox()
                : Container(
                    height: 50,
                    width: 150,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 05,
                        ),
                        Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            onPressed: () async {
                              setState(() {
                                uploadingImg = true;
                              });

                              await uploadPic(context);
                              Fluttertoast.showToast(
                                  msg: "Image Updating.....");
                              setState(() {
                                uploadingImg = false;
                              });
                            },
                            child: uploadingImg == false
                                ? Text(
                                    "Save Image",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : CircularProgressIndicator(
                                    color: Colors.white,
                                  )),
                      ],
                    ),
                  ),
            SizedBox(
              height: 0,
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Car Details:",
                    style: TextStyle(
                      color: Colors.lightGreen,
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    )),
              ),
            ),
            FutureBuilder(
              future: widget.refDB
                  .child('Drivers')
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .once()
                  .then((result) {
                setState(() {
                  dataResult = result;
                });
                return result;
              }),
              builder: (context, snapshot) {
                return Container(
                  child: snapshot.hasData
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 110,
                                  height: 95,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Icon(
                                          Icons.car_repair,
                                          size: 50,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 16),
                                        child: Text(
                                            dataResult.value["Car_Details"]
                                                    ["car_model"]
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.black38,
                                              letterSpacing: 1.5,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'OpenSans',
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 110,
                                  height: 95,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Icon(
                                          Icons.emoji_transportation,
                                          size: 50,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 14,
                                          top: 8,
                                        ),
                                        child: Text(
                                            "Year " +
                                                dataResult.value["Car_Details"]
                                                        ["car_model_year"]
                                                    .toString(),
                                            style: TextStyle(
                                              color: Colors.black38,
                                              letterSpacing: 1.5,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'OpenSans',
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 110,
                                  height: 95,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Icon(
                                          Icons.confirmation_number_outlined,
                                          size: 50,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 16, top: 8, right: 8),
                                        child: Text(
                                            dataResult.value["Car_Details"]
                                                    ["car_reg-no"]
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.black38,
                                              letterSpacing: 1.5,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'OpenSans',
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Car Color:",
                                    style: TextStyle(
                                      color: Colors.lightGreen,
                                      letterSpacing: 1.5,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Center(
                                  child: Text(
                                      dataResult.value["Car_Details"]
                                          ["car_color"],
                                      style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                      )),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 50,
                                width: 370)
                          ],
                        )
                      : SizedBox(),
                  height: 250,
                  width: 370,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Ride History",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.5,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          )),
                    ),
                    SizedBox(width: 150),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.history,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 70,
                width: 370),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Earinig History",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.5,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          )),
                    ),
                    SizedBox(width: 120),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.attach_money,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 70,
                width: 370),
            SizedBox(
              height: 20,
            ),

            /*FutureBuilder(
              future: widget.refDB
                  .child('Drivers')
                  .child(FirebaseAuth.instance.currentUser!.uid)
                  .once()
                  .then((result) {
                setState(() {
                  dataResult = result;
                });
                return result;
              }),
              builder: (context, snapshot) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: snapshot.hasData
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Name :",
                                    style: TextStyle(
                                      color: primary,
                                      letterSpacing: 1.5,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(dataResult.value["driver_name"].toString())
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Phone No. :",
                                    style: TextStyle(
                                      color: primary,
                                      letterSpacing: 1.5,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                    dataResult.value["driver_phone"].toString())
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("CINC :",
                                    style: TextStyle(
                                      color: primary,
                                      letterSpacing: 1.5,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(dataResult.value["driver_CNIC"].toString())
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Car Details",
                                style: TextStyle(
                                  color: primary,
                                  letterSpacing: 1.5,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Car Model :",
                                    style: TextStyle(
                                      color: primary,
                                      letterSpacing: 1.5,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(dataResult.value["Car_Details"]
                                        ["car_model"]
                                    .toString())
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Model year :",
                                    style: TextStyle(
                                      color: primary,
                                      letterSpacing: 1.5,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(dataResult.value["Car_Details"]
                                        ["car_model_year"]
                                    .toString())
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Car Reg No. :",
                                    style: TextStyle(
                                      color: primary,
                                      letterSpacing: 1.5,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(dataResult.value["Car_Details"]
                                        ["car_reg-no"]
                                    .toString()),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _image == null
                                ? SizedBox()
                                : Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: primary,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            uploadingImg = true;
                                          });

                                          await uploadPic(context);
                                          Fluttertoast.showToast(
                                              msg: "Image Updating.....");
                                          setState(() {
                                            uploadingImg = false;
                                          });
                                        },
                                        child: uploadingImg == false
                                            ? Text(
                                                "Save Image",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            : CircularProgressIndicator(
                                                color: Colors.white,
                                              )),
                                  )
                          ],
                        )
                      : SizedBox(),
                );
              },
            )*/
          ],
        ),
      ),
    );
  }
}
