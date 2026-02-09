import 'dart:math';

import 'package:flutter/material.dart';

class ColorService {
  static final List<Color> noteColors = [Color(0xffffffff), Color(0xfff28b81), Color(0xfffbf476), Color(0xffcdff90), Color(0xffa7feeb), Color(0xffcbf0f8), Color(0xffafcbfa)];

  static Color getRandomPastelColor() {
    return noteColors[Random().nextInt(noteColors.length)];
  }
}
