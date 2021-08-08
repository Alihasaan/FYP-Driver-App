import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ots_driver_app/Models/rideDetails.dart';
import 'package:ots_driver_app/Screens/mapPage.dart';
import 'package:ots_driver_app/main.dart';
import 'package:ots_driver_app/utilities/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class RideAlerts extends StatelessWidget {
  final RideDetails rideDetails;

  RideAlerts({Key? key, required this.rideDetails}) : super(key: key);
  DatabaseReference driverRideRef = db
      .child("Drivers")
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child("newRide");
  DatabaseReference reqRideRef = db.child("ride_requests");

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "New Ride Request!",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: primary,
                        child: ClipOval(
                          child: SizedBox(
                              width: 80,
                              height: 80,
                              child: Image.network(
                                  rideDetails.userPhotoURL.toString())),
                        ),
                      ),
                      SizedBox(
                        width: 21,
                      ),
                      Column(
                        children: [
                          Text(
                            rideDetails.userName.toString(),
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                          Text(rideDetails.userPhone.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 1.5,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text("From : ",
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'OpenSans',
                    )),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.pin_drop_rounded,
                          size: 40, color: Colors.lightBlueAccent),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(rideDetails.pickUpAddress.toString(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 1.5,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
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
                      letterSpacing: 1.5,
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'OpenSans',
                    )),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.pin_drop_outlined,
                        size: 40,
                        color: Colors.amberAccent,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(rideDetails.dropOffAddress.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.black87,
                            letterSpacing: 1.5,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Divider(
                  color: Colors.green,
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Decline".toUpperCase(),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: primary,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FlatButton(
                            onPressed: () async {
                              //await driverRideRef.set(rideDetails.rideId);
                              checkRideAvailability(context);
                            },
                            child: Text(
                              "Accept".toUpperCase(),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            )),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ), // bottom part
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: CircleAvatar(
                radius: 200,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                    child: SizedBox(
                  width: 150,
                  height: 100,
                  child: Image.asset(
                    "assets/taxi.png",
                    fit: BoxFit.contain,
                  ),
                ))),
          ),
        ) // top part
      ],
    );
  }

  void checkRideAvailability(context) {
    driverRideRef.once().then((DataSnapshot data) {
      String rideId = "";
      if (data.value != null) {
        rideId = data.value.toString();
      } else {
        Fluttertoast.showToast(msg: "Ride not Exist");
      }

      if (rideId == rideDetails.rideId) {
        driverRideRef.set("ride-accepted");
        db
            .child("ride_requests")
            .child(rideId)
            .child("ride-status")
            .set("Accepted");
        db
            .child("ride_requests")
            .child(rideId)
            .child("driver_id")
            .set(FirebaseAuth.instance.currentUser!.uid);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MapPage(
                      refDB: db,
                      rideInfo: rideDetails,
                    )));
      } else if (rideId == "Request Time Out") {
        Fluttertoast.showToast(msg: "Ride Timed Out");
        Navigator.pop(context);
      } else if (rideId == "cancelled") {
        Fluttertoast.showToast(msg: "Ride Cancelled");
        Navigator.pop(context);
      }
    });
  }
}
