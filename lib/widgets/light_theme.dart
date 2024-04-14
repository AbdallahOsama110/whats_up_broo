// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

import '../core/const/const.dart';

ThemeData lightTheme() {
  return ThemeData(
    textTheme: TextTheme(
      bodyMedium: TextStyle(
          color: kPrimaryColor, fontSize: 20, fontWeight: FontWeight.bold),
      bodySmall: TextStyle(color: kPrimaryColor),
      headlineLarge: TextStyle(
          fontSize: 30,
          color: kPrimaryColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'Courgette'),
      headlineMedium: TextStyle(
          fontSize: 25,
          color: kSecondryColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'Courgette'),
      headlineSmall: TextStyle(
          fontSize: 15, color: kPrimaryColor, fontWeight: FontWeight.bold),
    ),
    scaffoldBackgroundColor: kBodyColor,
    iconTheme: IconThemeData(color: Colors.white, size: 30),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStatePropertyAll(Colors.white),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: kPrimaryColor,
      titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontFamily: 'Courgette'),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
  );
}
