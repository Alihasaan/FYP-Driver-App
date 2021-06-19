import 'package:flutter/material.dart';
import 'package:ots_driver_app/Models/rideDetails.dart';
import 'package:ots_driver_app/utilities/constants.dart';

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class RideAlerts extends StatelessWidget {
  final RideDetails rideDetails;

  RideAlerts({Key? key, required this.rideDetails}) : super(key: key);

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    Text(
                      rideDetails.userName.toString(),
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
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
              ),
              SizedBox(
                height: 15,
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
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 1.5,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Divider(
                color: primary,
                height: 20,
                thickness: 06,
              ),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Decline",
                            style: TextStyle(fontSize: 18),
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
                        color: Colors.greenAccent,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Accept",
                            style: TextStyle(fontSize: 18),
                          )),
                    ),
                  )
                ],
              ),
            ],
          ),
        ), // bottom part
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: CircleAvatar(
                radius: 150,
                backgroundColor: Colors.white,
                child: ClipOval(
                    child: SizedBox(
                  width: 180,
                  height: 120,
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
}
