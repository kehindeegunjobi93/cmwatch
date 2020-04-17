import 'package:cmwatch/utilities/colors.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final IconData icons;
  final Function onPressed;

  const CustomDialog({@required this.title,
     this.description,
    @required this.buttonText,
    @required this.icons,
    @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context){
    return Container(
      height: 250,
      decoration: BoxDecoration(
          color: pColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12))
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(icons, size: 42, color: pColor,),
            ),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
            ),
          ),
          SizedBox(height: 24),
          Text(title, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
          SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: Text(description, style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
          ),
          SizedBox(height: 24),
          RaisedButton(onPressed: onPressed, child: Text(buttonText), color: Colors.white, textColor: pColor,)
        ],
      ),
    );
  }
}
