import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ots_driver_app/Notifications/pushNotificationService.dart';
import 'package:ots_driver_app/main.dart';
import 'package:ots_driver_app/utilities/configMaps.dart';
import 'package:ots_driver_app/utilities/constants.dart';

class MapPage extends StatefulWidget {
  DatabaseReference refDB;
  MapPage({required this.refDB, Key? key}) : super(key: key);

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
                      body: GoogleMap(
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
