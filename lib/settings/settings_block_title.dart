import 'package:flutter/material.dart';

class SettingsBlockTitle extends StatelessWidget{

  String? text;

  SettingsBlockTitle({
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 15.0, left: 10.0, right: 5.0, bottom: 5.0),
      child: Text(
        text ?? '',
        textAlign: TextAlign.left,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
    );
  }

}