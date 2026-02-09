import 'package:client/services/color.dart';
import 'package:flutter/material.dart';

import '../../api_modules/note.dart/note.dart';

class HomeViewModel with ChangeNotifier {
  final List<Note> _notesMoc = [
    Note(id: 1, title: "header1", content: "foo sazadfasdfasdf infasdj;flkasjd f;ao", color: ColorService.getRandomPastelColor()),
    Note(id: 2, title: "header2", content: "foo sazadfasdff info", color: ColorService.getRandomPastelColor()),
    Note(id: 3, title: "header3", content: "foo sazadfasdfasdf info", color: ColorService.getRandomPastelColor()),
    Note(id: 4, title: "header4", content: "foo  info", color: ColorService.getRandomPastelColor()),
    Note(id: 5, title: "header5", content: "foo bar baz qwerty additionl info", color: ColorService.getRandomPastelColor()),
    Note(
      id: 6,
      title: "header6",
      content: "foo bar a;lskdjf;alksjd;flkkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info",
      color: ColorService.getRandomPastelColor(),
    ),
    Note(
      id: 7,
      title: "header7",
      content: "foo bar a;lskdjf;alksjd;flkajsd;flkjas;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info",
      color: ColorService.getRandomPastelColor(),
    ),
    Note(
      id: 8,
      title: "header8",
      content: "foo bar a;lskdjf;alksjd;flk;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info",
      color: ColorService.getRandomPastelColor(),
    ),
    Note(
      id: 9,
      title: "header9",
      content: "foo bar a;lskdjf;alksjd;flka;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info",
      color: ColorService.getRandomPastelColor(),
    ),
    Note(
      id: 10,
      title: "header10",
      content: "foo bar a;lskdjf;alksjd;flka;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info",
      color: ColorService.getRandomPastelColor(),
    ),
    Note(
      id: 11,
      title: "header11",
      content: "foo bar a;lskdjf;alksjd;flkaa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info",
      color: ColorService.getRandomPastelColor(),
    ),
    Note(
      id: 12,
      title: "header12",
      content: "foo bar a;lskdjf;alksjd;flkaa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty and some additional info",
      color: ColorService.getRandomPastelColor(),
    ),
    Note(
      id: 13,
      title: "header13",
      content: "foo bar a;lskdjf;alksjd;flkldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty and some additional info",
      color: ColorService.getRandomPastelColor(),
    ),
    Note(
      id: 14,
      title: "header14",
      content: "foo bar a;lskdjf;alksjd;flkaa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty and some additional info",
      color: ColorService.getRandomPastelColor(),
    ),
    Note(
      id: 15,
      title: "header15",
      content: "foo bar a;lskdjf;alksjd;flka;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty and some additional info",
      color: ColorService.getRandomPastelColor(),
    ),
    Note(
      id: 16,
      title: "header16",
      content: "foo bar a;lskdjf;alksjd;flka;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty and some additional info",
      color: ColorService.getRandomPastelColor(),
    ),
    Note(id: 17, title: "header", content: "foo bar baz qwerty and some  info", color: ColorService.getRandomPastelColor()),
    Note(id: 18, title: "header", content: "foo bar baz qwerty and some  info", color: ColorService.getRandomPastelColor()),
    Note(id: 19, title: "header", content: "foo bar baz qwerty and some  info", color: ColorService.getRandomPastelColor()),
    Note(id: 20, title: "header", content: "foo bar baz qwerty and some  info", color: ColorService.getRandomPastelColor()),
    Note(id: 21, title: "header", content: "foo bar baz qwerty and some additional info", color: ColorService.getRandomPastelColor()),
  ];

  List<Note> get notes => _notesMoc;

  void changeColor({required Color newColor, required Note note}) {
    final _note = _notesMoc.firstWhere((n) => n.id == note.id);
    //_notesMoc[_note.id].color = newColor;
    _note.color = newColor;
    notifyListeners();
  }

  Future<void> delNote({required Note note}) async {
    _notesMoc.remove(note);
    notifyListeners();
  }
}
