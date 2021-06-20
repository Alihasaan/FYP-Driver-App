import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
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
        ? SizedBox(
            width: 150,
            height: 150,
            child: _image == null
                ? Image.network(
                    "https://cdn2.iconfinder.com/data/icons/avatars-99/62/avatar-370-456322-512.png",
                    fit: BoxFit.fill,
                  )
                : Image.file(File(_image!.path), fit: BoxFit.cover))
        : SizedBox(
            width: 150,
            height: 150,
            child: Image.network(
              FirebaseAuth.instance.currentUser!.photoURL.toString(),
              fit: BoxFit.fill,
            ),
          );
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
      body: Column(
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
          SizedBox(
            height: 15,
          ),
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
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 10, color: primary),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
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
                  padding: EdgeInsets.only(top: 60),
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
                Container(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
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
                        child: Text("Ali Hassan",
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                              child: Text("03035271607",
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                              child: Text("1234567891236",
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
                  ),
                ),
              ],
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
                              Text(dataResult.value["driver_phone"].toString())
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
                              Text(dataResult.value["Car_Details"]["car_model"]
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
                              Text(dataResult.value["Car_Details"]["car_reg-no"]
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
          ),
        ],
      ),
    );
  }
}
