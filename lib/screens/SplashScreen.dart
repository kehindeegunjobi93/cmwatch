import 'dart:async';
import 'package:cmwatch/screens/auth/Wrapper.dart';
import 'package:cmwatch/screens/dashboard.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseUser currentUser;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
         FirebaseAuth.instance.currentUser().then((res) async {
           if(res != null){
             Navigator.pushReplacement(context,
                 MaterialPageRoute(builder: (context) => Dashboard()),
             );
           }
           else {

             Navigator.pushReplacement(context,
                 MaterialPageRoute(builder: (context) =>
                     Wrapper()
                 ));
           }
         });
      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pColor,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 340.0,
                    height: 340.0,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.05),
                      shape: BoxShape.circle
                    ),
                  ),
                  Positioned(
                    top: 37.0,
                    left: 10.0,
                    right: 10.0,
                    child:     Container(
                      width: 260.0,
                      height: 260.0,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.1),
                          shape: BoxShape.circle
                      ),
                    ),
                  ),
                  Positioned(
                    top: 85.0,
                    left: 10.0,
                    right: 10.0,
                    child:     Container(
                      width: 160.0,
                      height: 160.0,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.15),
                          shape: BoxShape.circle
                      ),
                    ),
                  ),
                  Positioned(
                    top: 125.0,
                    left: 10.0,
                    right: 10.0,
                    child:     Container(
                      child: Icon(Icons.account_circle, size: 80.0, color: Colors.white,
                      )
                    ),
                  )
                ],
              ),
            Column(
              children: <Widget>[
                Text('Get started',
                  style: TextStyle(
                    fontSize: 55,
                    color: Colors.white
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text('If you\'re offered a seat on a rocket ship, don\'t ask what seat. Just get on.',
                    style: TextStyle(fontSize: 20, color: Color(0xFF9f9aff) ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
  ]
        ),

      ),
    );
  }
}
