import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmwatch/screens/robbery/ChatScreeen.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewCase extends StatefulWidget {

  @override
  _NewCaseState createState() => _NewCaseState();
}

class _NewCaseState extends State<NewCase> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;


  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    try {
    if(user != null){
      loggedInUser = user;
    } }
    catch(e){
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFf7f7fa),
     child: StreamBuilder(
         stream: Firestore.instance.collection("users").snapshots(),
         builder: (context, snapshot) {
           if(!snapshot.hasData){
             return Center(
               child: SpinKitRotatingPlain(
                 color: pColor,
                 size: 40.0,
               ),
             );
           } else {
             return ListView.builder(
                 padding: EdgeInsets.all(10.0),
                 itemCount: snapshot.data.documents.length,
                 itemBuilder: (context, index) => buildItem(context, snapshot.data.documents[index]),

             );
           }
         }
     ),
    
    );
  }


Widget buildItem(BuildContext context, DocumentSnapshot document) {
  if(document['email'] == loggedInUser.email) {
    return Container(
    );
  } else {

    return Container(
      child: FlatButton(
        child: Row(
          children: <Widget>[
            Material(
              child: document['photoUrl'] != null
                  ? CachedNetworkImage(
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: AlwaysStoppedAnimation<Color>(pColor),
                  ),
                  width: 50.0,
                  height: 50.0,
                  padding: EdgeInsets.all(15.0),
                ),
                imageUrl: document['photoUrl'],
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              )
                  : Icon(
                Icons.account_circle,
                size: 50.0,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              clipBehavior: Clip.hardEdge,
            ),
            Flexible(child: Container(
              child: Text('Name: ${document['fullName']}',
                style: TextStyle(color: Colors.white, fontSize: 21.0),
              ),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(10.0, 0, 0, 5.0),
            ))
          ],
        ),
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              ChatScreen(
                peerId: document.documentID,
                peerAvatar: document['photoUrl'],
                loggedInUser: loggedInUser,
              )
          ));
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('peerAvatar', document['photoUrl']);
        },
        color: Colors.black38,
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }
}

}


