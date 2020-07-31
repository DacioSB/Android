import 'package:flutter/material.dart';
import 'package:giphy/ui/home_page.dart';
import 'package:giphy/ui/colors.dart';

void main() {
  runApp(new MaterialApp(
    home: new Home(),
    theme: ThemeData(
        hintColor: Cols.lightPurple,
        primaryColor: Cols.white,
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Cols.lightPurple)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Cols.white)))),
  ));
}
