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
        color: Colors.transparent,
        elevation: 0,
      )),
};
