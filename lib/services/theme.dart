import 'package:flutter/material.dart';

class ThemeService {
  static const Color noteBackground = Color(0xff2d2d2d);
  static const Color noteBorderColor = Colors.cyan;

  static ThemeData defaultTheme = ThemeData(brightness: Brightness.dark, scaffoldBackgroundColor: const Color(0xff2d2d2d), primaryColor: Color(0xff06d001), useMaterial3: true);
}
