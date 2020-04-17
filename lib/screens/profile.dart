import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController controllerFullName;
  SharedPreferences prefs;

  String photoUrl = '';
  String id = '';
  String fullName = '';

  bool isLoading = false;
  File avatarImageFile;

  final FocusNode focusNodeFullname = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readFromServer();
  }

  void readFromServer() async {
//    prefs = await SharedPreferences.getInstance();

    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    final QuerySnapshot result = await Firestore.instance.collection("users")
        .where('uid', isEqualTo: firebaseUser.uid).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    fullName = documents[0]['fullName'];
    var pic = documents[0]['photoUrl'];
    setState(() {
      photoUrl = pic;
    });


    controllerFullName = TextEditingController(text: fullName);


  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = false;
      });
    }
  }

  void handleUpdateData() async{
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    var randomno = Random(25);
    final StorageReference reference = FirebaseStorage.instance.ref().child('profilepics/${randomno.nextInt(5000).toString()}.jpg');
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value){
      var userInfo = UserUpdateInfo();
       storageTaskSnapshot = value;
       var downloadUrl = storageTaskSnapshot.ref.getDownloadURL();
      userInfo.photoUrl = downloadUrl.toString();

      firebaseUser.updateProfile(userInfo).then((value){
       FirebaseAuth.instance.currentUser().then((user){
           Firestore.instance.collection('users').where('uid', isEqualTo: user.uid)
           .getDocuments()
           .then((docs){
             Firestore.instance.document('/users/${docs.documents[0].documentID}')
             .updateData({'fullName': fullName, 'photoUrl': photoUrl}).then((value){
               setState(() {
                 isLoading = false;
               });
               Fluttertoast.showToast(msg: "Proflie Updated");
             });
           }).catchError((e){
             setState(() {
               isLoading = false;
             });
             Fluttertoast.showToast(msg: e.toString());
           });
        }).catchError((e){
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'There was a problem while updating your data');
        });
      }).catchError((e){
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'There was a problem while updating your data');
      });
    }).catchError((e){
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.toString());
    });


    focusNodeFullname.unfocus();

    setState(() {
      isLoading = true;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          centerTitle: true,
          backgroundColor: pColor,
        ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Avatar
                Container(
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        (avatarImageFile == null)
                            ? (photoUrl != null
                            ? Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(pColor),
                              ),
                              width: 90.0,
                              height: 90.0,
                              padding: EdgeInsets.all(20.0),
                            ),
                            imageUrl: photoUrl,
                            width: 90.0,
                            height: 90.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(45.0)),
                          clipBehavior: Clip.hardEdge,
                        )
                            : Icon(
                          Icons.account_circle,
                          size: 90.0,
                          color: greyColor,
                        ))
                            : Material(
                          child: Image.file(
                            avatarImageFile,
                            width: 90.0,
                            height: 90.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(45.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: greyChat.withOpacity(0.5),
                          ),
                          onPressed: getImage,
                          padding: EdgeInsets.all(30.0),
                          splashColor: Colors.transparent,
                          highlightColor: greyColor,
                          iconSize: 30.0,
                        ),
                      ],
                    ),
                  ),
                  width: double.infinity,
                  margin: EdgeInsets.all(20.0),
                ),

                // Input
                Column(
                  children: <Widget>[
                    // Username
                    Container(
                      child: Text(
                        'Full Name',
                        style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: pColor),
                      ),
                      margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                    ),
                    Container(
                      child: Theme(
                        data: Theme.of(context).copyWith(primaryColor: pColor),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Your name',
                            contentPadding: new EdgeInsets.all(5.0),
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          controller: controllerFullName,
                          onChanged: (value) {
                            fullName = value;
                          },
                          focusNode: focusNodeFullname,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),

                // Button
                Container(
                  child: FlatButton(
                    onPressed: handleUpdateData,
                    child: Text(
                      'UPDATE',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    color: pColor,
                    highlightColor: new Color(0xff8d93a0),
                    splashColor: Colors.transparent,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                  ),
                  margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
                ),
              ],
            ),
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
          ),

          // Loading
          Positioned(
            child: isLoading
                ? Container(
              child: Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(pColor)),
              ),
              color: Colors.white.withOpacity(1.4),
            )
                : Container(),
          ),
        ],
      ),
    );
  }
}
