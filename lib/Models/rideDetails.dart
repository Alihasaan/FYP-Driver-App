import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails {
  String? rideId;
  LatLng? pickUpLatLong;
  LatLng? dropOffLatLong;
  String? pickUpAddress;
  String? dropOffAddress;
  String? userName;
  String? userPhotoURL;
  String? userPhone;

  RideDetails(
      {this.pickUpLatLong,
      this.pickUpAddress,
      this.dropOffLatLong,
      this.dropOffAddress,
      this.userName,
      this.userPhotoURL});
}
