import 'package:cmwatch/screens/robbery/add.dart';
import 'package:cmwatch/services/database.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class ExistingScreen extends StatefulWidget {
  @override
  _ExistingScreenState createState() => _ExistingScreenState();
}

class _ExistingScreenState extends State<ExistingScreen> {
  Stream robbery;
  DbMethods dbObj = new DbMethods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbObj.getRobberyReport().then((results) {
      setState(() {
        robbery = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf7f7fa),
      body: _robberyReportList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddRobbery()));
        },
        child: Icon(Icons.add),
        backgroundColor: pColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
    );
  }

  Widget _robberyReportList() {
    if (robbery != null) {
      return StreamBuilder(
          stream: robbery,
          builder: (context, snapshot){
            if(snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DateTime date = DateTime.parse(
                      snapshot.data.documents[index].data['time']
                          .toDate()
                          .toString());
                  var formattedDate = DateFormat("MMM d - H:m a").format(date);
                  return Column(children: <Widget>[
                    Container(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0, left: 18.0),
                          child: Text(
                            formattedDate,
                            style: TextStyle(color: greyColor, fontSize: 17),
                            textAlign: TextAlign.left,
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      margin: const EdgeInsets.all(16.0),
                      child: ExpandablePanel(
                        header: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: greyColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Location',
                                  style: TextStyle(color: greyColor),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 78.0),
                                  child: Text(
                                    snapshot.data.documents[index]
                                        .data['location'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        collapsed: Text(
                          snapshot.data.documents[index].data['description'],
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: greyColor),
                        ),
                        expanded: Text(
                          snapshot.data.documents[index].data['description'],
                          softWrap: true,
                        ),
                        hasIcon: true,
                      ),
                    ),
                  ]);
                },
              );
            } else {
              return Center(
                child: SpinKitThreeBounce(
                  size: 50.0,
                  color: pColor,
                ),
              );
            }
          });
    } else {
      return Center(
        child: SpinKitThreeBounce(
          size: 50.0,
          color: pColor,
        ),
      );
    }
  }

}
