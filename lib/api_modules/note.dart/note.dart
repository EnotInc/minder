import 'dart:math';
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Note {
  int id;
  String title;
  String content;
  Color? color;
  bool isNotify;

  Note({required this.id, required this.title, required this.content, this.color}) : isNotify = Random().nextBool();
}
