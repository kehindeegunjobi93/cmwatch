import 'package:cmwatch/services/database.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Existing extends StatefulWidget {
  @override
  _ExistingState createState() => _ExistingState();
}

class _ExistingState extends State<Existing> {

  Stream reportedCases;
  DbMethods dbObj = new DbMethods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbObj.getStolenItemsReport().then((results) {
      setState(() {
        reportedCases = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf7f7fa),
      body: _kidnappingReportList(),
    );
  }

  Widget _kidnappingReportList() {
    if (reportedCases != null) {
      return StreamBuilder(
          stream: reportedCases,
          builder: (context, snapshot){
            if(snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Column(children: <Widget>[
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
                                  'Location:',
                                  style: TextStyle(color: greyColor),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    snapshot.data.documents[index].data['your location'],
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
                          snapshot.data.documents[index].data['descriptions'],
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: greyColor),
                        ),
                        expanded: Column(
                          children: <Widget>[
                            Text(
                              snapshot.data.documents[index].data['descriptions'],
                              softWrap: true,
                            ),
                          ],
                        ),
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
