import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);


Color utopiaprimaryColor = Color(0xff282C4B);
Color utopiasecondaryColor = Color(0xff323761);
Color utopiabackgroundColor = Color(0xffFEFEFE);
Color utopiaotherColor = Color(0xff232D3B);
Color utopiaothersColor = Color(0xff5E6178);
Color utopiaErrorColor = Color(0xffff0000);


