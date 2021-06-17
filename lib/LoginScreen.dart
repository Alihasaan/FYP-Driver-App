import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ots_driver_app/AuthService.dart';
import 'package:ots_driver_app/main.dart';
import 'package:ots_driver_app/utilities/constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  final _CodeController = TextEditingController();

  late bool codeSent = false;
  final _formKey = GlobalKey<FormState>();

  late String verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(32),
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 90,
              ),
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Login",
                style: TextStyle(
                    color: primary, fontSize: 36, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    color: primary,
                    margin: EdgeInsets.only(top: 25),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Image.asset(
                          'assets/flag-wave-250.png',
                          width: 30.0,
                          height: 30.0,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "+92",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  _buildPhoneNoTF(),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                  child: Text("Login"),
                  textColor: Colors.white,
                  padding: EdgeInsets.all(16),
                  onPressed: () {
                    //code for sign in
                    if (_formKey.currentState!.validate()) {
                      verifyPhone("+92" + _phoneController.text);
                    }
                  },
                  color: primary,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              codeSent == true
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                            "Enter the 6-Digits Code Sent to your Phone Number.",
                            style: TextStyle(
                              color: priText,
                              fontSize: 12.0,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'OpenSans',
                            )),
                        Container(
                            padding: EdgeInsets.all(10),
                            width: 300,
                            child: PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: TextStyle(
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                              length: 6,

                              blinkWhenObscuring: true,
                              animationType: AnimationType.fade,
                              validator: (v) {
                                if (v!.length < 6) {
                                  return "6 digits required.";
                                } else {
                                  return null;
                                }
                              },
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                              ),
                              cursorColor: Colors.black,
                              animationDuration: Duration(milliseconds: 300),
                              enableActiveFill: true,

                              controller: _CodeController,
                              keyboardType: TextInputType.number,
                              boxShadows: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                  blurRadius: 10,
                                )
                              ],
                              onCompleted: (v) {
                                print("Completed");
                              },
                              // onTap: () {
                              //   print("Pressed");
                              // },

                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                              onChanged: (String value) {},
                            )),
                        SizedBox(
                          height: 16,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Container(
                            width: double.infinity,
                            child: FlatButton(
                              child: Text("Verify"),
                              textColor: Colors.white,
                              padding: EdgeInsets.all(16),
                              onPressed: () {
                                //code for sign in
                                if (codeSent == true) {
                                  AuthService().signInWithOTP(
                                      _CodeController.text,
                                      this.verificationId);
                                }
                              },
                              color: primary,
                            ),
                          ),
                        )
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildPhoneNoTF() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 20),
            child: Text(
              'Phone No.',
              style: TextStyle(color: priText),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            height: 60.0,
            width: 220,
            child: TextFormField(
              controller: _phoneController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your Phone No.";
                } else if (value.length < 10) {
                  return " Invalid Phone No. Format";
                } else if (value.length > 10) {
                  return " Invalid Phone No. Format";
                }
              },
              obscureText: false,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: new BorderSide(color: primary)),
                contentPadding: EdgeInsets.all(14.0),
                hintText: 'Enter your Phone No.',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
      print("SignIn SuccessFul");
    };

    final PhoneVerificationFailed verificationfailed = (authException) {
      print('Error');
      print('${authException.message}');
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      setState(() {
        verificationId = verId;
      });
      print("Auto Verify");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: (String verId, int? forceResend) {
          print("Verification Code Sent To" + phoneNo);
          setState(() {
            codeSent = true;
            verificationId = verId;
          });
        },
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
