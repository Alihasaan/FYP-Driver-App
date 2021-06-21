import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ots_driver_app/Models/rideDetails.dart';
import 'package:ots_driver_app/Notifications/pushNotificationService.dart';
import 'package:ots_driver_app/main.dart';
import 'package:ots_driver_app/utilities/configMaps.dart';
import 'package:ots_driver_app/utilities/constants.dart';

class MapPage extends StatefulWidget {
  final DatabaseReference refDB;
  final RideDetails rideInfo;
  MapPage({required this.refDB, required this.rideInfo, Key? key})
      : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // ignore: non_constant_identifier_names
  late DatabaseReference DBref = widget.refDB
      .child("Drivers")
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child("driver_status");

  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController newGoogleMapController;
  late var driver;
  late Position currentPosition;
  late DataSnapshot dataResult;
  void locatePosition() async {
    setState(() async {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    });

    LatLng positionLatLing =
        LatLng(currentPosition.altitude, currentPosition.latitude);

    CameraPosition cameraPosition =
        CameraPosition(target: positionLatLing, zoom: 30);
  }

  void getCurrentDriverInfo() {
    driver = FirebaseAuth.instance.currentUser;
    PushNotifications pushNotifications = PushNotifications();
    pushNotifications.initialize();
    pushNotifications.getToken();
  }

  @override
  void initState() {
    getCurrentDriverInfo();
    super.initState();
  }
  /*Future<DataSnapshot> getDriverStatus() async {
    dataResult = await db
        .child('Drivers')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("driver_status")
        .once();
    return dataResult;
  }*/

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db
            .child('Drivers')
            .child(FirebaseAuth.instance.currentUser!.uid)
            .child("driver_status")
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
                  ? Scaffold(
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.centerFloat,
                      floatingActionButton: Container(
                        margin: widget.rideInfo.rideId != null
                            ? EdgeInsets.only(left: 150, bottom: 220)
                            : null,
                        child: dataResult.value["driver_status"] == "offline"
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 100),
                                child: FloatingActionButton.extended(
                                    backgroundColor: primary,
                                    onPressed: () {
                                      getLiveLocationUpdates();
                                      makeDriverOnline();
                                    },
                                    label: Text('Go Online'),
                                    icon: Icon(
                                        Icons.insert_chart_outlined_outlined)))
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 100),
                                child: FloatingActionButton.extended(
                                    backgroundColor: Colors.lightGreen,
                                    onPressed: () {
                                      makeDriverOffline();
                                      removeQueryListener();
                                    },
                                    label: Text('Your Online'),
                                    icon: Icon(
                                        Icons.insert_chart_outlined_outlined)),
                              ),
                      ),
                      body: Stack(
                        children: [
                          GoogleMap(
                            padding: const EdgeInsets.only(top: 50),
                            mapType: MapType.normal,
                            myLocationEnabled: true,
                            compassEnabled: false,
                            tiltGesturesEnabled: false,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            myLocationButtonEnabled: true,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(33.6844, 73.0479), zoom: 12),
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                              newGoogleMapController = controller;
                              locatePosition();
                            },
                          ),
                          // ignore: unnecessary_null_comparison
                          widget.rideInfo.rideId != null
                              ? Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: () =>
                                        FocusScope.of(context).unfocus(),
                                    child: Container(
                                        height: 300,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: priText,
                                                blurRadius: 16,
                                                spreadRadius: 0.5,
                                                offset: Offset(0.7, 0.7))
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Center(
                                              child: Text("Rider Details",
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'OpenSans',
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.lightGreen[100],
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 65,
                                                  ),
                                                  CircleAvatar(
                                                    radius: 30,
                                                    child: Image.network(widget
                                                        .rideInfo.userPhotoURL
                                                        .toString()),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                          widget
                                                              .rideInfo.userName
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontFamily:
                                                                  'OpenSans')),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.phone_android,
                                                          ),
                                                          Text(
                                                              widget.rideInfo
                                                                  .userPhone
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontFamily:
                                                                      'OpenSans')),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Text("From : ",
                                                style: TextStyle(
                                                  letterSpacing: 1.5,
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'OpenSans',
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.pin_drop_rounded,
                                                      size: 30,
                                                      color: Colors
                                                          .lightBlueAccent),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        widget.rideInfo
                                                            .pickUpAddress
                                                            .toString(),
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          letterSpacing: 1.5,
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily:
                                                              'OpenSans',
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text("To: ",
                                                style: TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'OpenSans',
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.pin_drop_outlined,
                                                    size: 30,
                                                    color: Colors.amberAccent,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                      widget.rideInfo
                                                          .dropOffAddress
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: 'OpenSans',
                                                      ))
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Center(
                                              child: Container(
                                                width: 270,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: primary,
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        "Arrived!",
                                                        style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 100,
                                                    ),
                                                    Icon(
                                                      Icons.drive_eta_sharp,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                  ))
                              : SizedBox(),
                        ],
                      ),
                    )
                  : SizedBox());
        });
  }

  void makeDriverOnline() async {
    DBref.set({"driver_status": "online-searching"});
    print("!----------------------------Driver Status Updated");
    await Geofire.initialize("availableDrivers");
    await Geofire.setLocation(FirebaseAuth.instance.currentUser!.uid,
        currentPosition.latitude, currentPosition.longitude);

    DBref.onValue.listen((event) {});
  }

  void makeDriverOffline() async {
    DBref.set({"driver_status": "offline"});
    await Geofire.removeLocation(FirebaseAuth.instance.currentUser!.uid);
    removeQueryListener();
    DBref.onDisconnect();

    mapPageStreamSub.cancel();
  }

  void removeQueryListener() async {
    await Geofire.stopListener();
  }

  void getLiveLocationUpdates() {
    print("!----------------------------Location Updated");
    mapPageStreamSub =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;

      Geofire.setLocation(FirebaseAuth.instance.currentUser!.uid,
          position.latitude, position.longitude);
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
}
