import 'package:cmwatch/screens/stolen/existing.dart';
import 'package:cmwatch/screens/stolen/new.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:flutter/material.dart';

class StolenItemScreen extends StatefulWidget {
  @override
  _StolenItemScreenState createState() => _StolenItemScreenState();
}

class _StolenItemScreenState extends State<StolenItemScreen> {
  final GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text('Stolen Item(s)', style: TextStyle(color: Colors.white),),
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
                          left: BorderSide(color: Colors.grey),
                          // provides to left side
                          right: BorderSide(color: Colors.grey),
                          bottom: BorderSide(
                              color: pColor, width: 8.0) // for right side
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
              child: TabBarView(children: [
                NewCase(scaffoldKey: _scaffoldState,),
                Existing(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}