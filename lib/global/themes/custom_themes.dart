import 'package:flutter/material.dart';

enum AppTheme {
  DarkTheme,
  LightTheme,
}

final appThemes = {
  AppTheme.LightTheme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      bottomAppBarColor: Colors.blueAccent,
      bottomAppBarTheme: BottomAppBarTheme(
        color: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        actionsIconTheme: IconThemeData(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black),
        textTheme:
            TextTheme(display1: TextStyle(color: Colors.black, fontSize: 11)),
        brightness: Brightness.light,
        color: Colors.transparent,
        elevation: 0,
      )),
  AppTheme.DarkTheme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.green,
      bottomAppBarColor: Colors.blueAccent,
      bottomAppBarTheme: BottomAppBarTheme(
        color: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        actionsIconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
        color: Colors.transparent,
        elevation: 0,
      )),
};
