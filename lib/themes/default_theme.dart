import 'package:flutter/material.dart';

class DefaultTheme {
  static const Color primary = Colors.amber; 
  static const Color secondary = Colors.grey;
  static final Color primaryHover = Colors.amber.shade600; 

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primary, 
    appBarTheme: AppBarTheme(
      backgroundColor: primary, 
      foregroundColor: Colors.white, 
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: primary, 
        foregroundColor: Colors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: secondary, 
        foregroundColor: Colors.white,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary, 
      foregroundColor: Colors.white,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: primary), 
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primary), 
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primary, 
    appBarTheme: AppBarTheme(
      backgroundColor: primary, 
      foregroundColor: Colors.white, 
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary, 
      foregroundColor: Colors.white,
    ),
  );
}
