import 'package:cached_network_image/cached_network_image.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _fireStore = Firestore.instance;

class ChatScreen extends StatefulWidget {

  final String peerId;
  final String peerAvatar;
  final FirebaseUser loggedInUser;

  const ChatScreen({Key key, this.peerId, this.peerAvatar, this.loggedInUser}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState(peerId: peerId, peerAvatar: peerAvatar, loggedInUser: loggedInUser);
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  final String peerId;
  final String peerAvatar;
  final FirebaseUser loggedInUser;
  String loggedInUserPhoto;

  String messageText;

  _ChatScreenState({this.peerId, this.peerAvatar, this.loggedInUser});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getPeerPhoto();
  }

  getPeerPhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String peerAvatar = prefs.getString('peerAvatar');
    });
  }

  getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentUserPhoto = prefs.getString('userPhoto');
    setState(() {
      loggedInUserPhoto = currentUserPhoto;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: pColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(
              loggedInUser: loggedInUser,
              loggedInUserPhoto: loggedInUserPhoto
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 6.0,
                              offset: Offset(0, 3.0),
                            ),
                          ]),
                      child: TextField(
                        controller: messageTextController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          hintText: 'Say something...',
                          hintStyle: TextStyle(fontSize: 20.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _fireStore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email
                      });
                    },
                    child: Icon(Icons.send, color: pColor, size: 43.0,)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final FirebaseUser loggedInUser;
  final String loggedInUserPhoto;

  const MessagesStream({Key key, this.loggedInUser, this.loggedInUserPhoto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection('messages').snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages = snapshot.data.documents.reversed;
          List<MessageBubble> messageBubbles = [];
          for(var message in messages){
            final messageText = message.data['text'];
            final messageSender = message.data['sender'];
            final currentUser = loggedInUser.email;
            final String currentUserPhoto = loggedInUser.photoUrl;


            final messageBubble = MessageBubble(
                sender: messageSender,
                text: messageText,
                isMe: currentUser == messageSender,
                currentUserPhoto: currentUserPhoto
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubbles,
            ),
          );
        }

    );
  }
}


class MessageBubble extends StatelessWidget {

  final String sender;
  final String text;
  final bool isMe;
  final String currentUserPhoto;

  const MessageBubble({Key key, this.sender, this.text, this.isMe, this.currentUserPhoto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
//          Text(sender),
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 2.0,
                margin: isMe ? EdgeInsets.only(bottom: 40.0,) : EdgeInsets.only(bottom: 40.0, left: 30),
                child: Material(
                  borderRadius: BorderRadius.circular(7.0),
                  elevation: 2.0,
                  color: isMe ? greyChat : pColor,
                  child: Padding(
                    padding: isMe ?
                    const EdgeInsets.only(left: 18.0, top: 20.0, bottom: 10.0, right: 28.0)
                        :  const EdgeInsets.only(left: 38.0, top: 20.0, bottom: 10.0, right: 24.0),
                    child: Text('$text', style: TextStyle(
                        color: Colors.white,
                        fontSize: 23.0
                    ),),
                  ),
                ),
              ),

              Positioned(
              bottom: 80,
              child: Padding(
                padding: isMe ? const EdgeInsets.only(left: 145.0) : EdgeInsets.only(right: 45.0),
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
                  imageUrl: isMe ? 'https://firebasestorage.googleapis.com/v0/b/cmwatch-11ea1.appspot.com/o/profilepics%2F1442.jpg?alt=media&token=66cefb0b-8c7f-456b-a743-af8a28a98fca' : '',
//                  width: 60.0,
//                  height: 60.0,
                 fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0)
                      ),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),

            ],
          ),
        ],
      ),
    );
  }
}
