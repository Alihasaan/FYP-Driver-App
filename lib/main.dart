import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ots_driver_app/AuthService.dart';
import 'package:ots_driver_app/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ots_driver_app/Screens/InfoForm.dart';
import 'package:ots_driver_app/Screens/accountPage.dart';
import 'package:ots_driver_app/Screens/mapPage.dart';
import 'package:ots_driver_app/utilities/constants.dart';

late final DatabaseReference db;
Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final FirebaseApp app = await Firebase.initializeApp();
    db = FirebaseDatabase(app: app).reference();
    await Firebase.initializeApp();
  } on FirebaseException catch (e) {
    print(e.message);
  }
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    print("message recieved");
    print(event.notification!.body);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Message clicked!');
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthService().handleAuth());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Widget _buildSignUpBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: 200,
      child: RaisedButton(
          elevation: 5.0,
          onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfoFrom(dbRef: db),
                    ))
              },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: Text(
            'Get Started ',
            style: TextStyle(
              color: primary,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          )),
    );
  }

  String phone = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
  String? name = FirebaseAuth.instance.currentUser!.displayName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        actions: [
          IconButton(
              onPressed: () {
                AuthService().signOut();
              },
              icon: Icon(Icons.logout))
        ],
        title: Text(
          widget.title,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: primary,
                child: ClipOval(
                  child: SizedBox(
                      width: 150,
                      height: 150,
                      child: FirebaseAuth.instance.currentUser!.photoURL == null
                          ? Image.network(
                              "https://cdn2.iconfinder.com/data/icons/avatars-99/62/avatar-370-456322-512.png",
                              fit: BoxFit.fill,
                            )
                          : Image.network(
                              FirebaseAuth.instance.currentUser!.photoURL
                                  .toString(),
                              fit: BoxFit.cover)),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FirebaseAuth.instance.currentUser!.displayName != null
                ? Text(
                    name!,
                    style: TextStyle(fontSize: 20),
                  )
                : SizedBox(),
            SizedBox(
              height: 10,
            ),
            Text(
              phone,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            _buildSignUpBtn(context),
          ],
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    MyHomePage(title: "Taxi Driver App"),
    MapPage(refDB: db),
    AccountPage(refDB: db)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_sharp),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
