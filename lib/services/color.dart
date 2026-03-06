import 'dart:math';

import 'package:flutter/material.dart';

import 'package:color/color.dart' as color_lib;

class ColorService {
  static final List<Color> noteColors = [Color(0xffffffff), Color(0xfff28b81), Color(0xfffbf476), Color(0xffcdff90), Color(0xffa7feeb), Color(0xffcbf0f8), Color(0xffafcbfa)];

  static Color getRandomPastelColor() {
    return noteColors[Random().nextInt(noteColors.length)];
  }

  Color fromString(String? colorStr) {
    if (colorStr == null) {
      return getRandomPastelColor();
    }
    try {
      var color = color_lib.HexColor(colorStr.substring(1));
      return Color.fromARGB((255), (color.r * 255).toInt(), (color.g * 255).toInt(), (color.b * 255).toInt());
    } catch (error) {
      return getRandomPastelColor();
    }
  }
}
