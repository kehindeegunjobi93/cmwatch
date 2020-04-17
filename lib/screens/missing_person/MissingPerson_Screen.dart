import 'package:cached_network_image/cached_network_image.dart';
import 'package:cmwatch/screens/missing_person/add.dart';
import 'package:cmwatch/screens/missing_person/person_details.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:cmwatch/services/database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MissingPersonScreen extends StatefulWidget {
  @override
  _MissingPersonScreenState createState() => _MissingPersonScreenState();
}

class _MissingPersonScreenState extends State<MissingPersonScreen> {
  Stream missingPerson;
  DbMethods dbObj = new DbMethods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbObj.getMissingPersonReport().then((results) {
      setState(() {
        missingPerson = results;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Missing Persons', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: pColor,

      ),
      body: _missingPersonList(),
      floatingActionButton: FloatingActionButton(onPressed: (){
         Navigator.push(context, MaterialPageRoute(builder: (context)
           => AddMissing()
         ));
      },
      backgroundColor: pColor,
      child: Icon(Icons.add),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      ),
    );
  }

  Widget _missingPersonList(){
   if(missingPerson != null){
     return StreamBuilder(
         stream: missingPerson,
         builder: (context, snapshot){
           if(snapshot.data != null) {
             return ListView.builder(
                 itemCount: snapshot.data.documents.length,
                 scrollDirection: Axis.vertical,
                 shrinkWrap: true,
                 itemBuilder: (context, index) {
                   return Card(
                     elevation: 8,
                     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6.0),
                     child: Container(
                       decoration: BoxDecoration(color: bgGrey),
                       child: ListTile(
                         onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context) =>
                               PersonDetails(
                                 imgUrl: snapshot.data.documents[index].data['missingPersonImgUrl'],
                                 age: snapshot.data.documents[index].data['age'],
                                 height: snapshot.data.documents[index].data['height'],
                                 location: snapshot.data.documents[index].data['lastLocation'],
                                 outfit: snapshot.data.documents[index].data['lastOutfit'],
                                 description: snapshot.data.documents[index].data['descriptions'],
                                 fullName: snapshot.data.documents[index].data['fullName'],
                               )
                           ));
                         },
                         contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                         leading: Container(
                           //  padding: EdgeInsets.only(right: 12.0),
                           decoration: BoxDecoration(
                               border: Border(
                                   right: BorderSide(width: 1.0, color: Colors.white)
                               )
                           ),
                           child: ClipRRect(
                             borderRadius: BorderRadius.circular(10.0),
                             child: CachedNetworkImage(
                               placeholder: (context, url) => Container(
                                 child: CircularProgressIndicator(
                                   strokeWidth: 1.0,
                                   valueColor: AlwaysStoppedAnimation<Color>(pColor),
                                 ),
                                 width: 50.0,
                                 height: 50.0,
                                 padding: EdgeInsets.all(15.0),
                               ),
                               imageUrl: snapshot.data.documents[index].data['missingPersonImgUrl'],
                               height: 100,
                               width: 75,
                               fit: BoxFit.cover,
                               ),
                           ),
                           ),

                         title: Text(
                           snapshot.data.documents[index].data['fullName'],
                           style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 23.0),
                         ),
                         subtitle: RichText(
                           text: TextSpan(
                             style:  TextStyle(fontSize: 16.0, color: Colors.black54),
                             children: <TextSpan>[
                               TextSpan(text: snapshot.data.documents[index].data['descriptions'].substring(0, 80)),
                               TextSpan(text: '  ...read more', style: TextStyle(color: pColor)),
                             ]
                           )
                         ),
                         trailing: Icon(Icons.keyboard_arrow_right, size: 30.0,),
                       ),
                     ),

                   );
                 });
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
