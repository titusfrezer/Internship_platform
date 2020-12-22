import 'package:flutter/material.dart';
import 'package:internship_platform/Utilities/variables.dart';
class ReusableTextField extends StatelessWidget {
 final controller;
 final inputFormat;
 final inputType;
 final hintText;
 final line;

 ReusableTextField(this.controller,this.inputFormat,this.inputType,this.hintText,this.line);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[

        Expanded(
          child: TextField(

              inputFormatters: [inputFormat],
              keyboardType: inputType,
              decoration: InputDecoration(
                  fillColor: myColor.myWhite,
                  labelText: hintText
              ),
              maxLines: line,
              controller: controller),
        )
      ],
    );
  }
}
Widget reusableRow( ) {

}