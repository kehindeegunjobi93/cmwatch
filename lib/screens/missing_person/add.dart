
import 'dart:io';

import 'package:cmwatch/services/database.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:cmwatch/widgets/custom_bigtextfield.dart';
import 'package:cmwatch/widgets/custom_button.dart';
import 'package:cmwatch/widgets/custom_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddMissing extends StatefulWidget {
  @override
  _AddMissingState createState() => _AddMissingState();
}

class _AddMissingState extends State<AddMissing> {
  final formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final lastOutfitController = TextEditingController();
  final descriptionController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();

  DbMethods dbObj = new DbMethods();

  File _selectedImage;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = image;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text('Missing Person', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: pColor,

      ),
      body: Container(
        color: bgGrey,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              child: _selectedImage != null ?
                              CircleAvatar(
                                backgroundColor: Colors.black87,
                                backgroundImage: FileImage(_selectedImage),
                                radius: 50.0,
                              )
                              :
                              CircleAvatar(
                                backgroundColor: Colors.black87,
                                backgroundImage: AssetImage("assets/images/account.png"),
                                radius: 50.0,
                              ),
                            ),
                          Positioned(
                            bottom: 5,

                            child: FlatButton(
                              onPressed: (){
                                  getImage();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 58.0),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: Icon(Icons.camera_alt, color: Colors.white, size: 30,),

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [pColor, Color(0xFF7862d4)]
                                    )
                                  ),
                                ),
                              ),
                            ),
                          )
                          ],
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                          flex: 1,
                          child: Text('Upload missing person picture', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)))
                    ],
                  ),
                  SizedBox(height: 20.0),
                  CustomField(
                    controller: nameController,
                    hintText: 'Full name',
                    //validator: (val) => val.isEmpty ? 'This field cannot be empty' : null,
                  ),
                  SizedBox(height: 25.0),
                  CustomField(
                    controller: locationController,
                    hintText: 'Last known location',
                    //: (val) => val.isEmpty ? 'This field cannot be empty' : null,
                  ),
                  SizedBox(height: 25.0),
                  CustomField(
                    controller: lastOutfitController,
                    hintText: 'Last outfit',
                    validator: (val) => val.isEmpty ? 'This field cannot be empty' : null,
                  ),
                  SizedBox(height: 25.0),
                  CustomBigTextField(
                    controller: descriptionController,
                    hintText: 'Descriptions and Additional Information',
                    num: 8,
                    validator: (val) => val.isEmpty ? 'This field cannot be empty' : null,
                  ),
                  SizedBox(height: 25.0),
                  CustomField(
                    controller: ageController,
                    hintText: 'Age',
                    inputType: TextInputType.number,
                    validator: (val) => val.isEmpty ? 'This field cannot be empty' : null,
                  ),
                  SizedBox(height: 25.0),
                  CustomField(
                    controller: heightController,
                    hintText: 'Height',
                    inputType: TextInputType.number,
                  ),
                  SizedBox(height: 40.0),
                  CustomButton(
                    text: 'Report Case',
                    color: Color(0xFFffb900),
                    onPress: (){
                        final FormState form = formKey.currentState;
                        if (formKey.currentState.validate()) {
                          form.save();
                          uploadData();
                        }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
    ),
    );

  }

  void uploadData() async {
    if(_selectedImage != null){
      StorageReference storageReference = FirebaseStorage.instance.ref().child("missingPersons").child("${randomAlphaNumeric(9)}.jpg");
      final StorageUploadTask task = storageReference.putFile(_selectedImage);
      var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
      Map<String, String> missingPersonData = {
        "missingPersonImgUrl": downloadUrl,
        "fullName": nameController.text,
        "lastLocation": locationController.text,
        "lastOutfit": lastOutfitController.text,
        "descriptions": descriptionController.text,
        "age": ageController.text,
        "height": heightController.text

      };
      dbObj.createMissingPersonReport(missingPersonData).then((result){
        _scaffoldState.currentState.showSnackBar(
          SnackBar(
            duration: new Duration(seconds: 2),
            content: new Text(
                'Your report has been added. Thanks'),
            backgroundColor: pColor.withOpacity(0.9),
          ),
        );
        nameController.clear();
        locationController.clear();
        lastOutfitController.clear();
        descriptionController.clear();
        ageController.clear();
        heightController.clear();
      }).catchError((e) {
        print(e);
        _scaffoldState.currentState.showSnackBar(
          SnackBar(
            duration: new Duration(seconds: 2),
            content: new Text(
                'There was a problem adding your report.'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } else {

    }
  }
}
