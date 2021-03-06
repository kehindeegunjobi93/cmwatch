import 'package:cmwatch/services/database.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:cmwatch/widgets/custom_bigtextfield.dart';
import 'package:cmwatch/widgets/custom_button.dart';
import 'package:cmwatch/widgets/custom_field.dart';
import 'package:flutter/material.dart';

class NewCase extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const NewCase({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _NewCaseState createState() => _NewCaseState();
}

class _NewCaseState extends State<NewCase> {
  final formKey = new GlobalKey<FormState>();

  final locationController = TextEditingController();
  final transportController = TextEditingController();
  final personsController = TextEditingController();
  final descriptionController = TextEditingController();

  DbMethods dbObj = new DbMethods();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: bgGrey,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                CustomField(
                  controller: locationController,
                  hintText: 'Your Location',
                  validator: (val) => val.isEmpty ? "This field cannot be empty" : null,
                ),
                SizedBox(height: 25.0),
                CustomField(
                  controller: transportController,
                  hintText: 'Means of Transportation',
                  validator: (val) => val.isEmpty ? "This field cannot be empty" : null,
                ),
                SizedBox(height: 25.0),
                CustomField(
                  controller: personsController,
                  hintText: 'Number of Persons',
                  inputType: TextInputType.number,
                  validator: (val) => val.isEmpty ? "This field cannot be empty" : null,
                ),
                SizedBox(height: 25.0),
                CustomBigTextField(
                  controller: descriptionController,
                  hintText: 'Descriptions and Additional Information',
                  num: 8,
                  validator: (val) => val.isEmpty ? "This field cannot be empty" : null,
                ),
                SizedBox(height: 40.0),
                CustomButton(
                  text: 'Report Case',
                  color: Color(0xFFffb900),
                  onPress: () {
                    final FormState form = formKey.currentState;
                    if (formKey.currentState.validate()) {
                      form.save();
                      Map<String, dynamic> kidnappingData = {
                       'your location': locationController.text,
                       'transport means': transportController.text,
                       'persons number': personsController.text,
                        'descriptions': descriptionController.text
                      };
                      dbObj.createKidnappingReport(kidnappingData).then((result) {
                        widget.scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            duration: new Duration(seconds: 2),
                            content: new Text(
                                'Your report has been added. Thanks'),
                            backgroundColor: pColor.withOpacity(0.9),
                          ),
                        );
                        locationController.clear();
                        transportController.clear();
                        personsController.clear();
                        descriptionController.clear();
                      }).catchError((e) {
                        print(e);
                       widget.scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            duration: new Duration(seconds: 2),
                            content: new Text(
                                'There was a problem adding your report.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                      }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
