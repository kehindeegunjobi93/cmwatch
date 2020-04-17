import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {

  final String hintText;
  final inputType;
  final bool obscure;
  final Function validator;
  final Function onChanged;
  final controller;

  const CustomField({@required this.hintText,
    this.inputType,
    this.obscure = false,
    this.validator,
    this.onChanged, this.controller
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: 65,
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
            child: TextFormField(
              controller: controller,
              onChanged: onChanged,
              validator: validator,
              keyboardType: inputType,
              obscureText: obscure,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 18.0, bottom: 12.0),
                border: InputBorder.none,
                hintText: hintText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}