import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ots_driver_app/LoginScreen.dart';
import 'package:ots_driver_app/main.dart';

class AuthService {
  signIn(AuthCredential authCrd) {
    FirebaseAuth.instance.signInWithCredential(authCrd);
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signInWithOTP(smsCode, verId) {
    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    signIn(authCredential);
  }

  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return MyStatefulWidget();
          } else {
            return LoginScreen();
          }
        });
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email Can not be empty.";
    }
    return "";
  }
}

class CNICValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email Can not be empty.";
    }
    return "";
  }
}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Name Can not be empty.";
    } else if (value.length <= 2) {
      return "Name too Short";
    } else if (value.length > 15) {
      return "Name too Long";
    }
    return "";
  }
}

/*
class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password Can not be empty.";
    } else if (value.length < 8) {
      return "Password too short. ";
    }
    return "";
  }
}
*/
class PhoneValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Please enter your Phone No.";
    } else if (value.length < 10) {
      return " Invalid Phone No. Format";
    } else if (value.length > 10) {
      return " Invalid Phone No. Format";
    }
    return "";
  }
}
