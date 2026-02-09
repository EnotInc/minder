import 'package:flutter/material.dart';

class ThemeService {
  static const Color mainBackground = Color(0xff2d2d2d);
  static const Color noteBorderColor = Colors.cyan;

  static ThemeData defaultTheme = ThemeData(
    splashColor: Colors.black,
    highlightColor: Colors.black,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff2d2d2d),
    useMaterial3: true,

    appBarTheme: AppBarThemeData(backgroundColor: mainBackground, centerTitle: true, scrolledUnderElevation: 0.0),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: mainBackground,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 2, color: Colors.white),
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(overlayColor: Colors.black, foregroundColor: Colors.white),
    ),
  );
}
