import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:cmwatch/utilities/constants.dart';
import 'package:cmwatch/widgets/custom_alert.dart';
import 'package:cmwatch/widgets/custom_bigtextfield.dart';
import 'package:cmwatch/widgets/custom_button.dart';
import 'package:cmwatch/widgets/custom_field.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
//  Position _currentPosition;
//  String _currentCity;
//  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;

  String _email;
  String _password;
  String _fullName;
  String _country;
  String _state;
  String _address;
  bool _loading = false;
  bool _autoValidate = false;
  String errorMsg = "";

  @override
  void initState() {
    super.initState();
//    getCurrentLocation();
//    getAddressFromLatLng();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return 'Enter your email';
    if (!regex.hasMatch(value))
      return 'Email format is invalid';
     else
      return null;
  }

  String pwdValidator(String value) {
    if (value.length < 6) {
      return 'Password must be longer than 6 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                CustomField(
                  hintText: 'FullName',
                  onChanged: (val) {
                    setState(() {
                      _fullName = val;
                    });
                  },
                  validator: (value) => value.isEmpty ? 'Enter your full name' : null,
                ),
                SizedBox(height: 25.0),
                CustomField(
                  hintText: 'Email',
                  inputType: TextInputType.emailAddress,
                  onChanged: (val) {
                    setState(() {
                      _email = val;
                    });
                  },
                  validator: emailValidator
                ),
                SizedBox(height: 25.0),
                CustomField(
                  hintText: 'Password',
                  obscure: true,
                  onChanged: (val) {
                    setState(() {
                      _password = val;
                    });
                  },
                  validator: (value) => value.length < 6 ? 'Password cannot be less than 6 characters' : null,
                ),
//                SizedBox(height: 25.0),
//                FlatButton(
//                    onPressed: getCurrentLocation,
//                    child: Text("Get Current Location")),
                SizedBox(height: 25.0),
                CustomField(
                  hintText: 'Country',
                  onChanged: (val) {
                    setState(() {
                      _country = val;
                    });
                  },
                  validator: (val) => val.isEmpty ? 'Enter your country' : null,
                ),
//            Container(
//              width: MediaQuery.of(context).size.width / 1.2,
//              height: 65,
//              padding:
//              EdgeInsets.only(top: 1, left: 16, right: 16, bottom: 1),
//              decoration: BoxDecoration(
//                  borderRadius: BorderRadius.all(Radius.circular(10)),
//                  color: Colors.white,
//                  boxShadow: [
//                    BoxShadow(
//                      color: Colors.black38,
//                      blurRadius: 16.0,
//                      offset: Offset(0, 2),
//                    ),
//                  ]),
//              child: CountryListPick(
//                isShowFlag: false,
//                isShowTitle: true,
//                isDownIcon: true,
//                onChanged: (CountryCode code){
//                  print(code.name);
//                },
//              ),
//            ),
                SizedBox(height: 25.0),
                CustomField(
                  hintText: 'State',
                  onChanged: (val) {
                    _state = val;
                  },
                  validator: (val) => val.isEmpty ? 'Enter your state' : null,
                ),
                SizedBox(height: 25.0),
//                Container(
//                  child: Column(
//                    children: <Widget>[
//                      Container(
//                        width: MediaQuery.of(context).size.width / 1.2,
//                        height: 85,
//                        padding: EdgeInsets.only(
//                            top: 1, left: 16, right: 16, bottom: 1),
//                        decoration: BoxDecoration(
//                            borderRadius: BorderRadius.all(Radius.circular(10)),
//                            color: Colors.white,
//                            boxShadow: [
//                              BoxShadow(
//                                color: Colors.black38,
//                                blurRadius: 16.0,
//                                offset: Offset(0, 2),
//                              ),
//                            ]),
//                        child: TextFormField(
//                          maxLines: 8,
//                          style: TextStyle(fontSize: 20),
//                          decoration: InputDecoration(
//                            contentPadding:
//                                EdgeInsets.only(top: 18.0, bottom: 12.0),
//                            border: InputBorder.none,
//                            hintText: 'Address',
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
                CustomBigTextField(
                  hintText: 'Address',
                  onChanged: (val) {
                    setState(() {
                      _address = val;
                    });
                  },
                  validator: (val) => val.isEmpty ? 'Enter your address' : null,
                  num: 8,
                ),
                SizedBox(height: 25.0),
                Container(
                  child: _loading
                      ? SpinKitThreeBounce(
                          color: pColor,
                          size: 40.0,
                        )
                      : CustomButton(
                          text: 'SIGN UP',
                          color: btnColor,
                          onPress: registerUser),
                ),
                Text(
                  errorMsg,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void registerUser() async {
    final FormState form = formKey.currentState;
    if (formKey.currentState.validate()) {
      form.save();
      setState(() {
        _loading = true;
      });
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: _email, password: _password)).user;
        var userUpdateInfo = new UserUpdateInfo();
        userUpdateInfo.displayName = _fullName;
        userUpdateInfo.photoUrl = 'https://firebasestorage.googleapis.com/v0/b/cmwatch-11ea1.appspot.com/o/account.png?alt=media&token=4278ca64-f9ae-4998-86e1-f77fd3224d75';
        user.updateProfile(userUpdateInfo);
        await user.sendEmailVerification();
        showDialog(
            context: context,
            builder: (BuildContext context) {
             return CustomDialog(
                  title: 'Email Sent',
                  description: 'Dear $_fullName, A verification email will be sent to $_email within the next 2 minutes',
                  icons: Icons.mail,
                  onPressed: () {
                    Navigator.pushNamed(context, '/wrapper');
                  },
                  buttonText: 'Ok');
            });
        Firestore.instance.collection("users").document().setData({
          'fullName': _fullName,
          'email': _email,
          'country': _country,
          'state': _state,
          'address': _address,
          'uid': user.uid,
          'photoUrl': 'https://firebasestorage.googleapis.com/v0/b/cmwatch-11ea1.appspot.com/o/account.png?alt=media&token=4278ca64-f9ae-4998-86e1-f77fd3224d75'
        }).then((onValue) {
          setState(() {
            _loading = false;
          });
        });
      } catch (error) {
        switch (error.code) {
          case "ERROR_EMAIL_ALREADY_IN_USE":
            {
              setState(() {
                errorMsg = "This email is already in use.";
                _loading = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      title: 'Error',
                      description: errorMsg,
                      buttonText: 'Okay',
                      icons: Icons.error,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    );
                  });
            }
            break;
          case "ERROR_WEAK_PASSWORD":
            {
              setState(() {
                errorMsg = "This password must be 6 chracters long or more";
                _loading = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      title: 'Error',
                      description: errorMsg,
                      buttonText: 'Okay',
                      icons: Icons.error,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    );
                  });
            }
            break;
          default:
            {
              setState(() {
                errorMsg = "";
                _loading = true;
              });
            }
        }
      }
    }
  }

//  getCurrentLocation() async {
//    await geolocator
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//        .then((Position position) {
//      setState(() {
//        _currentPosition = position;
//      });
//      getAddressFromLatLng();
//    }).catchError((e) {
//      print(e);
//    });
//  }
//
//  getAddressFromLatLng() async {
//    try{
//      List<Placemark> p = await geolocator.placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
//      Placemark place = p[0];
//
//      setState(() {
//        _currentCity = "${place.locality}";
//      });
//      print(_currentCity);
//    } catch(e){
//      print(e);
//    }
//  }
}
