import 'dart:math';

import 'package:flutter/material.dart';

class HomeViewModel with ChangeNotifier {
  final List<Note> _notesMoc = [
    Note(1, "header1", "foo sazadfasdfasdf infasdj;flkasjd f;ao"),
    Note(2, "header2", "foo sazadfasdff info"),
    Note(3, "header3", "foo sazadfasdfasdf info"),
    Note(4, "header4", "foo  info"),
    Note(5, "header5", "foo bar baz qwerty additionl info"),
    Note(6, "header6", "foo bar a;lskdjf;alksjd;flkkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info"),
    Note(7, "header7", "foo bar a;lskdjf;alksjd;flkajsd;flkjas;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info"),
    Note(8, "header8", "foo bar a;lskdjf;alksjd;flk;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info"),
    Note(9, "header9", "foo bar a;lskdjf;alksjd;flka;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info"),
    Note(10, "header10", "foo bar a;lskdjf;alksjd;flka;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info"),
    Note(11, "header11", "foo bar a;lskdjf;alksjd;flkaa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info"),
    Note(12, "header12", "foo bar a;lskdjf;alksjd;flkaa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty and some additional info"),
    Note(13, "header13", "foo bar a;lskdjf;alksjd;flkldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty and some additional info"),
    Note(14, "header14", "foo bar a;lskdjf;alksjd;flkaa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty and some additional info"),
    Note(15, "header15", "foo bar a;lskdjf;alksjd;flka;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty and some additional info"),
    Note(16, "header16", "foo bar a;lskdjf;alksjd;flka;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty and some additional info"),
    Note(17, "header", "foo bar baz qwerty and some  info"),
    Note(18, "header", "foo bar baz qwerty and some  info"),
    Note(19, "header", "foo bar baz qwerty and some  info"),
    Note(20, "header", "foo bar baz qwerty and some  info"),
    Note(21, "header", "foo bar baz qwerty and some additional info"),
  ];

  List<Note> get notes => _notesMoc;

  void setNoteColor({required int noteOrder, required Color newColor}) {
    _notesMoc[noteOrder].color = newColor;
  }

  Future<void> delNote({required Note note}) async {
    _notesMoc.remove(note);
    notifyListeners();
  }
}

class Note {
  int id;
  String title;
  String content;
  Color? color;
  bool isNotify;

  Note(this.id, this.title, this.content) : isNotify = Random().nextBool();
}
