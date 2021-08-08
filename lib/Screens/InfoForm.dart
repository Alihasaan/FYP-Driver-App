import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ots_driver_app/Screens/carInfoForm.dart';

import 'package:ots_driver_app/utilities/constants.dart';

import 'package:firebase_database/firebase_database.dart';

class InfoFrom extends StatefulWidget {
  final DatabaseReference dbRef;
  const InfoFrom({
    Key? key,
    required this.dbRef,
  }) : super(key: key);

  @override
  _InfoFromState createState() => _InfoFromState();
}

class _InfoFromState extends State<InfoFrom> {
  TextEditingController namectrl = new TextEditingController();
  TextEditingController cnicctrl = new TextEditingController();
  TextEditingController emailctrl = new TextEditingController();
  TextEditingController errorControl = new TextEditingController();
  bool _obscureText = true;
  bool signin = true;
  bool processing = false;
  bool clicked = false;
  late Map driverPinfo;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
                color: Colors.white,
                height: double.infinity,
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 40.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),
                        Text(
                          'Fill your Personal Info.',
                          style: TextStyle(
                            color: priText,
                            fontFamily: 'OpenSans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 70,
                          color: primary,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        formUi(),
                        SizedBox(
                          height: 35,
                        ),
                      ],
                    )))));
  }

  Widget formUi() {
    bool check;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 12,
            ),
            Text(
              "Your Name ",
              style: TextStyle(fontSize: 10, color: priText),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              child: Theme(
                data: new ThemeData(
                  primaryColor: primary,
                  primaryColorDark: Colors.red,
                ),
                child: new TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name Can not be empty.";
                    } else if (value.length <= 2) {
                      return "Name too Short";
                    } else if (value.length > 15) {
                      return "Name too Long";
                    }
                  },
                  controller: namectrl,
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: new BorderSide(color: primary)),
                      prefixIcon: Icon(
                        Icons.portrait,
                      ),
                      hintText: 'Name'),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "Your CNIC No. ",
              style: TextStyle(fontSize: 10, color: priText),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Theme(
                data: new ThemeData(
                  primaryColor: primary,
                  primaryColorDark: Colors.red,
                ),
                child: new TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "CNIC Can not be empty.";
                    } else if (value.length <= 2) {
                      return "CNIC too Short";
                    } else if (value.length > 13) {
                      return "CNIC too Long";
                    } else if (value.contains(RegExp(r'[A-Z]'))) {
                      return "CNIC cannot contains Alphabets";
                    }
                  },
                  controller: cnicctrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(
                    hintText: 'CNIC',
                    helperText: "CNIC must be 13 digits long.",
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: new BorderSide(color: primary)),
                    prefixIcon: Icon(
                      Icons.credit_card_sharp,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email (Optional) ",
                    style: TextStyle(fontSize: 10, color: priText),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Theme(
                    data: new ThemeData(
                      primaryColor: primary,
                      primaryColorDark: Colors.red,
                    ),
                    child: new TextFormField(
                      controller: emailctrl,
                      validator: (value) {
                        if (!value!.contains('@') && !(value.length == 0)) {
                          return "Email Invalid.";
                        } else if (value.length < 5 && !(value.length == 0)) {
                          return "Email Invalid.";
                        }
                      },
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: new BorderSide(color: primary)),
                        hintText: 'Email',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Center(
              child: MaterialButton(
                  color: Colors.white,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minWidth: 230,
                  height: 45,
                  onPressed: () {
                    check = _formKey.currentState!.validate();

                    if (check) {
                      print(processing);
                      saveDriverIndo();
                      print("!------------button clicked");

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CarInfoForm(dbRef: widget.dbRef),
                          ));
                    }
                  },
                  child: processing == false
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: primary,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Contiune ',
                              style: TextStyle(
                                color: primary,
                                letterSpacing: 1.5,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ],
                        )
                      : CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          color: primary,
                        )),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  void saveDriverIndo() async {
    setState(() {
      processing = true;
    });
    await FirebaseAuth.instance.currentUser!.updateProfile(
      displayName: namectrl.text,
    );
    emailctrl.text.isNotEmpty
        ? FirebaseAuth.instance.currentUser!.updateEmail(emailctrl.text)
        : print("Email Not Updated");
    Map driverStatus = {"driver_status": "off"};
    driverPinfo = {
      "driver_name": namectrl.text,
      "driver_CNIC": cnicctrl.text,
      "driver_phone": FirebaseAuth.instance.currentUser!.phoneNumber,
      "driver_status": driverStatus
    };

    widget.dbRef
        .child("Drivers")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .set(driverPinfo);
    setState(() {
      processing = false;
    });
  }
}
