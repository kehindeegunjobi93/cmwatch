import 'package:cmwatch/screens/auth/LoginScreen.dart';
import 'package:cmwatch/screens/auth/RegisterScreen.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  PageController _pageController = PageController();

  double currentPage = 0;


  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      setState(() {
       currentPage = _pageController.page;
      });
    });

    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: _button(),
            ),
            SizedBox(height: 20.0,),
            Expanded(child: PageView(
              controller: _pageController,
              children: <Widget>[
                LoginScreen(),
                RegisterScreen()
              ],
            ))
          ],
        ),
      )
    );
  }

  Widget _button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
                onPressed: (){
                  _pageController.previousPage(duration: Duration(milliseconds: 500),
                      curve: Curves.bounceInOut);
                },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: currentPage < 0.5 ? Colors.transparent : pColor)
              ),
                color: currentPage < 0.5 ? pColor : Colors.white,
                textColor: currentPage < 0.5 ? Colors.white : pColor,
                padding: EdgeInsets.all(14.0),
                child: Text('SIGN IN'),
            ),
            SizedBox(width: 32,),
            MaterialButton(
              onPressed: (){
                _pageController.nextPage(duration: Duration(milliseconds: 500),
                    curve: Curves.bounceInOut);
              },
              shape: RoundedRectangleBorder(
                side: BorderSide(color: currentPage > 0.5 ? Colors.transparent : pColor),
                  borderRadius: BorderRadius.circular(12)
              ),
              color: currentPage > 0.5 ? pColor : Colors.white,
              textColor: currentPage > 0.5 ? Colors.white : pColor,
              padding: EdgeInsets.all(14.0),
              child: Text('SIGN UP'),
            ),
          ],
        );
  }
}
