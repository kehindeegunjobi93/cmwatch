import 'package:cmwatch/services/database.dart';
import 'package:cmwatch/utilities/colors.dart';
import 'package:cmwatch/widgets/custom_bigtextfield.dart';
import 'package:cmwatch/widgets/custom_button.dart';
import 'package:cmwatch/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';


class AddRobbery extends StatefulWidget {
  @override
  _AddRobberyState createState() => _AddRobberyState();
}

class _AddRobberyState extends State<AddRobbery> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

  final locationController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();

  DbMethods dbObj = new DbMethods();
  final format = DateFormat("yyyy-MM-dd HH:mm");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text('Add Robbery', style: TextStyle(color: Colors.white),),
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
                  CustomField(
                    controller: locationController,
                    hintText: 'Location',
                    validator: (val) => val.isEmpty ? "This field cannot be empty" : null,
                  ),
                  SizedBox(height: 25.0),
                  Container(
                    padding:
                    EdgeInsets.only(top: 1, left: 16, right: 16, bottom: 1),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 16.0,
                            offset: Offset(0, 2),
                          ),
                        ]),
                    child: DateTimeField(
                      controller: timeController,
                      format: format,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime:
                            TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 18.0, bottom: 12.0),
                        border: InputBorder.none,
                        hintText: 'Choose Date and Time',
                      ),
                    ),
                  ),
                  SizedBox(height: 25.0),
                  CustomBigTextField(
                    controller: descriptionController,
                    num: 8,
                    hintText: 'Descriptions and Additional\nInformation',
                    validator: (val) => val.isEmpty ? "This field cannot be empty" : null,
                  ),
                  SizedBox(height: 40.0),
                  CustomButton(
                    text: 'Report Robbery',
                    color: Color(0xFFffb900),
                    onPress: () {
                      final FormState form = formKey.currentState;
                      if (formKey.currentState.validate()) {
                        form.save();
                        Map<String, dynamic> robberyData = {
                          'location': locationController.text,
                          'time': DateTime.parse(timeController.text),
                          'description': descriptionController.text
                        };
                        dbObj.createRobberyReport(robberyData).then((result) {
                          _scaffoldState.currentState.showSnackBar(
                            SnackBar(
                              duration: new Duration(seconds: 2),
                              content: new Text(
                                  'Your report has been added. Thanks'),
                              backgroundColor: pColor.withOpacity(0.9),
                            ),
                          );
                          locationController.clear();
                          timeController.clear();
                          descriptionController.clear();
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


}
