import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ots_driver_app/utilities/constants.dart';
import 'package:firebase_database/firebase_database.dart';

class CarInfoForm extends StatelessWidget {
  final DatabaseReference dbRef;
  CarInfoForm({Key? key, required this.dbRef}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  TextEditingController modelctrl = new TextEditingController();
  TextEditingController modelyearctrl = new TextEditingController();
  TextEditingController platenumctrl = new TextEditingController();
  TextEditingController colorctrl = new TextEditingController();
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
                          'Fill your Taxi Details.',
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
                          Icons.local_taxi_rounded,
                          size: 70,
                          color: primary,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        formUi(context),
                        SizedBox(
                          height: 35,
                        ),
                      ],
                    )))));
    ;
  }

  Widget formUi(BuildContext context) {
    bool check;
    Map carInfo;
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
            Row(
              children: [
                Text(
                  "Car Model :  ",
                  style: TextStyle(fontSize: 15, color: priText),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  width: 220,
                  child: Theme(
                    data: new ThemeData(
                      primaryColor: primary,
                      primaryColorDark: Colors.red,
                    ),
                    child: new TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Model Can not be empty.";
                        } else if (value.length <= 2) {
                          return "Model too Short";
                        } else if (value.length > 15) {
                          return "Model too Long";
                        }
                      },
                      controller: modelctrl,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: new BorderSide(color: primary)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Text(
                  "Model Year :",
                  style: TextStyle(fontSize: 15, color: priText),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  width: 150,
                  child: Theme(
                    data: new ThemeData(
                      primaryColor: primary,
                      primaryColorDark: Colors.red,
                    ),
                    child: new TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Model Year Can not be empty.";
                        } else if (value.length <= 2) {
                          return "Model Year too Short";
                        } else if (value.length > 15) {
                          return "Model Year too Long";
                        }
                      },
                      controller: modelyearctrl,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: new BorderSide(color: primary)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Text(
                  "Car Reg No :",
                  style: TextStyle(fontSize: 15, color: priText),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  width: 170,
                  child: Theme(
                    data: new ThemeData(
                      primaryColor: primary,
                      primaryColorDark: Colors.red,
                    ),
                    child: new TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Car Reg No.Can not be empty.";
                        } else if (value.length <= 2) {
                          return "Car Reg No. too Short";
                        } else if (value.length > 15) {
                          return "Car Reg No. too Long";
                        }
                      },
                      controller: platenumctrl,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: new BorderSide(color: primary)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Text(
                  "Car Color :   ",
                  style: TextStyle(fontSize: 15, color: priText),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  width: 150,
                  child: Theme(
                    data: new ThemeData(
                      primaryColor: primary,
                      primaryColorDark: Colors.red,
                    ),
                    child: new TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Car Color";
                        }
                      },
                      controller: colorctrl,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: new BorderSide(color: primary)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 60.0,
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
                  onPressed: () => {
                        check = _formKey.currentState!.validate(),
                        if (check)
                          {
                            print(check),
                            carInfo = {
                              "car_model": modelctrl.text,
                              "car_model_year": modelyearctrl.text,
                              "car_reg-no": platenumctrl.text,
                              "car_color": colorctrl.text
                            },
                            dbRef
                                .child("Drivers")
                                .child(FirebaseAuth.instance.currentUser!.uid)
                                .child("Car_Details")
                                .set(carInfo),
                            print("!------------button clicked"),
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst),
                          }
                      },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.done,
                        size: 18,
                        color: primary,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Done ',
                        style: TextStyle(
                          color: primary,
                          letterSpacing: 1.5,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ],
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
}
