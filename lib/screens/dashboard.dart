import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmwatch/screens/auth/LoginScreen.dart';
import 'package:cmwatch/screens/auth/Wrapper.dart';
import 'package:cmwatch/screens/profile.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<Choice> choices = const <Choice>[
    const Choice(title: 'Profile', icon: Icons.person),
    const Choice(title: 'Log Out', icon: Icons.exit_to_app)
  ];

  void onItemMenuPress(Choice choice){
    if (choice.title == 'Log Out'){
      FirebaseAuth auth = FirebaseAuth.instance;
      auth.signOut().then((res) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Wrapper()),
        );
      });
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((res) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userPhoto', res.photoUrl);

      });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: pColor,
        title: Text('CM Watch', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context){
              return choices.map((Choice choice){
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(choice.icon, color: pColor,),
                        Container(width: 10.0,),
                        Text(choice.title, style: TextStyle(color: pColor),)
                      ],
                    ));
              }).toList();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
         children: <Widget>[
           dashboardCards('Report Robbery',
               'Report a crime scene',
               Icons.notifications_none,
               Color(0xFF3497fd),
               Colors.white,
               Colors.white70,
               (){
             Navigator.pushNamed(context, '/robbery');
               }
           ),
           dashboardCards(
               'Kidnapping',
               'Quickly contact your hotline',
               Icons.people_outline, Color(0xFFe54e4e),
               Colors.white, Colors.white70,
               () {
                 Navigator.pushNamed(context, '/kidnapping');
               }
           ),
           dashboardCards(
               'Missing Persons',
               'Report a missing person case',
               Icons.chat_bubble_outline,
               Colors.white, Colors.black87,
               Color(0xFFcdf2f8),
               (){
                 Navigator.pushNamed(context, '/missing');
               }
           ),
             dashboardCards(
                 'Stolen Item(s)',
                 'Report theft and stolen properties',
                 Icons.location_on, Colors.white,
                 Colors.black87, Colors.grey,
                 () {
                   Navigator.pushNamed(context, '/stolen');
                 }
             ),
           dashboardCards(
               'Report a Case',
               'Report any abused or victimized case',
               Icons.insert_drive_file, Colors.white,
               Colors.black87, Color(0xFFcdf2f8),
               () {
                 Navigator.pushNamed(context, '/report');
               }
           ),
           SizedBox(height: 20,)

         ],
        ),
      )
    );
  }

  Widget dashboardCards(String title, String subtitle, IconData icon, Color bgColor, Color fontColor, Color iconColor, Function func){
    return GestureDetector(
      onTap: func,
      child: Padding(
        padding: EdgeInsets.only(top: 20.0, left: 15.0, right: 17.0),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          elevation: 4.0,
          child: Container(
            height: 125.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: bgColor
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 260,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500, color: fontColor),),
                    ),
                    Text(subtitle, style: TextStyle(fontSize: 17, color: fontColor)),
              ]
                    ),
                  ),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Icon(icon, size: 84, color: iconColor,),
                  ),)
                ],

              ),
            ),
          ),
        ),
      ),
    );
  }

  void handleSignOut() {
    FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut().then((res) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Wrapper()),
                  );
                });
              }
  }



class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
