import 'package:cmwatch/screens/auth/Wrapper.dart';
import 'package:cmwatch/screens/kidnapping/KidnappingScreen.dart';
import 'package:cmwatch/screens/missing_person/MissingPerson_Screen.dart';
import 'package:cmwatch/screens/report_case/ReportScreen.dart';
import 'package:cmwatch/screens/robbery/RobberyScreen.dart';
import 'package:cmwatch/screens/SplashScreen.dart';
import 'package:cmwatch/screens/auth/LoginScreen.dart';
import 'package:cmwatch/screens/auth/RegisterScreen.dart';
import 'package:cmwatch/screens/dashboard.dart';
import 'package:cmwatch/screens/stolen/StolenItemsScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
         initialRoute: '/',
         routes: {
        '/': (context) => SplashScreen(),
        '/wrapper': (context) => Wrapper(),
        '/dashboard': (context) => Dashboard(),
         '/robbery': (context) => RobberyScreen(),
           '/kidnapping': (context) => KidnappingScreen(),
           '/missing': (context) => MissingPersonScreen(),
           '/stolen': (context) => StolenItemScreen(),
           '/report': (context) => ReportCaseScreen()
      },
    );
  }
}


