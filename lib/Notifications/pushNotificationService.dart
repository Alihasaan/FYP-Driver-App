import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ots_driver_app/main.dart';
import 'dart:io' show Platform;

class PushNotifications {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initialize() async {}

  Future<String?> getToken() async {
    String? token = await messaging.getToken();
    print("!----Token::");
    print(token);
    db
        .child("Drivers")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("token")
        .set(token);
    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }

  String? getRideRequestId(Map<String, dynamic> message) {
    if (Platform.isAndroid) {
      print("!-----------------!");
      print(message["ride-request-id"]);
      return message["ride-request-id"];
    } else {}
  }
}
