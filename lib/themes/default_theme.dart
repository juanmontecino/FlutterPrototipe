import 'package:flutter/material.dart';

class DefaultTheme {
  static const Color primary = Colors.amber;
  static const Color secondary = Colors.grey;
  static final Color primaryHover = Colors.amber.shade600;

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    dividerColor: Colors.grey[300],
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
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle: const TextStyle(color: primary),
    hintStyle: const TextStyle(color: Colors.grey),
    labelStyle: const TextStyle(color: Colors.black),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: primary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: primary),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    dividerColor: Colors.grey[700],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[700],
        foregroundColor: Colors.white,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle: const TextStyle(color: primary),
    hintStyle: TextStyle(color: Colors.grey[400]),
    labelStyle: const TextStyle(color: Colors.white),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[700]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: primary),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  );
}
