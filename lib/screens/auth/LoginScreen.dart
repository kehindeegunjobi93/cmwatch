import 'package:cmwatch/screens/dashboard.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:cmwatch/widgets/custom_alert.dart';
import 'package:cmwatch/widgets/custom_button.dart';
import 'package:cmwatch/widgets/custom_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool autoValidate = false;
  String errorMsg = '';

  String email= '';
  String password = '';


  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return 'Email field cannot be empty';
    if (!regex.hasMatch(value))
      return 'Email format is invalid';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Center(
          child: Form(
            key: _formKey,
            autovalidate: autoValidate,
            child: Column(
              children: <Widget>[
                CustomField(
                  hintText: 'Email',
                  inputType: TextInputType.emailAddress,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  validator: emailValidator,
                ),
                SizedBox(height: 25.0),
                CustomField(
                  hintText: 'Password',
                  obscure: true,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  validator: (value) => value.isEmpty ? 'Password field cannot be empty' : null,
                ),
                SizedBox(height: 25.0),
                Container(
                  child:
                  loading ?
                  SpinKitThreeBounce(
                    color: pColor,
                    size: 40.0,
                  )                      :
                  CustomButton(
                    onPress: loginUser,
                    text: 'LOGIN',
                    color: btnColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void loginUser() async {
    if(_formKey.currentState.validate()){
      setState(() {
        loading = true;
      });
      try {
        FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user;
        user.isEmailVerified ?
         Navigator.pushReplacementNamed(context, '/dashboard')
        :
          showDialog(context: context,
              builder: (BuildContext context){
                return CustomDialog(
                  title: 'Error',
                  description: 'You have not verified your email address.',
                  buttonText: 'Dismiss',
                  icons: Icons.error,
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                );
              });

        setState(() {
          loading = false;
        });

      } catch (error) {
        switch(error.code){
          case "ERROR_USER_NOT_FOUND":
            {
              setState((){
                errorMsg = "There is no user with such entries. Please try again.";
                loading = false;
              });
              showDialog(context: context,
                  builder: (BuildContext context){
                    return CustomDialog(
                      title: 'Error',
                      description: errorMsg,
                      buttonText: 'Dismiss',
                      icons: Icons.error,
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    );
                  }
              );
            }
            break;
          case "ERROR_WRONG_PASSWORD":
            {
              setState(() {
                errorMsg = "Password doesn\'t match your email";
                loading = false;
              });
              showDialog(context: context,
                  builder: (BuildContext context){
                    return CustomDialog(
                      title: 'Error',
                      description: errorMsg,
                      buttonText: 'Dismiss',
                      icons: Icons.error,
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    );
                  }
              );
            }
            break;
          default:
            {
              setState(() {
                errorMsg = "";
              });
            }
        }
      }
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }
  }





