
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cmwatch/screens/robbery/RobberyScreen.dart';
import 'package:cmwatch/screens/robbery/existing.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonDetails extends StatefulWidget {

  final String imgUrl;
  final String description;
  final String age;
  final String fullName;
  final String height;
  final String location;
  final String outfit;

  const PersonDetails({Key key, this.imgUrl, this.description, this.age, this.fullName, this.height, this.location, this.outfit}) : super(key: key);

  @override
  _PersonDetailsState createState() => _PersonDetailsState();
}

class _PersonDetailsState extends State<PersonDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Missing Person', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: pColor,
      ),
      body: Container(
       // width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              placeholder: (context, url) => Container(
                child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                  valueColor: AlwaysStoppedAnimation<Color>(pColor),
                ),
                width: 50.0,
                height: 50.0,
                padding: EdgeInsets.all(15.0),
              ),
              imageUrl: widget.imgUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
//            Image.network(widget.imgUrl,
//              fit: BoxFit.cover,
//              width: double.infinity,
//              height: 300,
//            ),
            Positioned(
              top: 250,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32)
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.fullName,
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                      ),
                      Text(widget.location, style: TextStyle(fontSize: 21),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('${widget.age} years', style: TextStyle(fontSize: 21),),
                  Container(
//                    width: MediaQuery.of(context).size.width/0.2,
                    child: RaisedButton(
                      elevation: 5.0,
                      onPressed: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context) =>
                               RobberyScreen()
                         ));
                      },
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Color(0xFF454f63),
                      child: Text(
                        'REPORT SEEN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  )
                        ],
                      ),

                      Text(widget.description,
                        style: TextStyle(fontSize: 20, ),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text('Height: ${widget.height}', style: TextStyle(fontSize: 20),),
                          //SizedBox(width: 12.0),
                          Text('Last Outfit: ${widget.outfit}', style: TextStyle(fontSize: 20))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
