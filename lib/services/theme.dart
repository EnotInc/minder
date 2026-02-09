import 'package:flutter/material.dart';

class ThemeService {
  static const Color mainBackground = Color(0xff2d2d2d);
  static const Color authColor = Color(0xff1f1f1f);

  static ThemeData defaultTheme = ThemeData(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff2d2d2d),
    useMaterial3: true,

    appBarTheme: const AppBarThemeData(backgroundColor: mainBackground, centerTitle: true, scrolledUnderElevation: 0.0),

    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),

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
