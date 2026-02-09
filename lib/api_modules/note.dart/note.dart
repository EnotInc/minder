import 'dart:math';
import 'dart:ui';

//TODO: rewritte with json serializeble
class Note {
  int id;
  String title;
  String content;
  Color? color;
  bool isNotify;

  Note({required this.id, required this.title, required this.content, this.color}) : isNotify = Random().nextBool();
}
