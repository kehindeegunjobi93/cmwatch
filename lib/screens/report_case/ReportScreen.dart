import 'package:cmwatch/screens/report_case/existing.dart';
import 'package:cmwatch/screens/report_case/new.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:flutter/material.dart';

class ReportCaseScreen extends StatefulWidget {
  @override
  _ReportCaseScreenState createState() => _ReportCaseScreenState();
}

class _ReportCaseScreenState extends State<ReportCaseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text('Report Case', style: TextStyle(color: Colors.white),),
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