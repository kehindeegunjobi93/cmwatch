import 'package:cmwatch/screens/robbery/existing.dart';
import 'package:cmwatch/screens/robbery/new.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RobberyScreen extends StatefulWidget {

  @override
  _RobberyScreenState createState() => _RobberyScreenState();
}

class _RobberyScreenState extends State<RobberyScreen> {


  List<Widget> containers = [
    NewCase(),
    ExistingScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Robbery', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: pColor,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxHeight: 150.0),
              child: Material(
                color: Colors.white,
                child: TabBar(
                    indicator: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey), // provides to left side
                        right: BorderSide(color: Colors.grey),
                        bottom: BorderSide(color: pColor, width: 8.0)// for right side
                      ),
                    ),
                    tabs: <Widget>[
                      Tab(
                        text: 'New Case',
                      ),
                      Tab(
                        text: 'Existing',
                      ),
                    ]),
              ),
            ),
            Expanded(
                  child: TabBarView(children: containers),
            ),
          ],
        ),
      ),
    );
  }
}
