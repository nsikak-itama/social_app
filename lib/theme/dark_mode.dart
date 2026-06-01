import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Color.fromARGB(255, 9, 9, 9),
    background: Colors.grey.shade900,
    primary: Colors.grey.shade600,
    // primary: Color.fromARGB(255, 105, 105, 105),
    secondary: Colors.grey.shade800,
    // secondary: Color.fromARGB(255, 20, 20, 20),
    inversePrimary: Colors.grey.shade300,
    // inversePrimary: Color.fromARGB(255, 195, 195, 195),
    tertiary: Colors.white,
    // tertiary: Color.fromARGB(255, 29, 29, 29),
    secondaryContainer: Colors.white,
  ),
  scaffoldBackgroundColor: Color.fromARGB(255, 9, 9, 9)
);