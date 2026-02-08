import 'dart:math';

import 'package:flutter/material.dart';

import '../../services/theme.dart';

class HomeViewModel with ChangeNotifier {
  final List<Note> notes = [
    Note(1, "header", "foo sazadfasdfasdf infasdj;flkasjd f;ao"),
    Note(1, "header", "foo sazadfasdff info"),
    Note(1, "header", "foo sazadfasdfasdf info"),
    Note(1, "header", "foo  info"),
    Note(1, "header", "foo bar baz qwerty additionl info"),
    Note(1, "header", "foo bar a;lskdjf;alksjd;flkkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info"),
    Note(1, "header", "foo bar a;lskdjf;alksjd;flkajsd;flkjas;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info"),
    Note(1, "header", "foo bar a;lskdjf;alksjd;flk;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info"),
    Note(1, "header", "foo bar a;lskdjf;alksjd;flka;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info"),
    Note(1, "header", "foo bar a;lskdjf;alksjd;flka;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info"),
    Note(1, "header", "foo bar a;lskdjf;alksjd;flkaa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty additional info"),
    Note(1, "header", "foo bar a;lskdjf;alksjd;flkaa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty and some additional info"),
    Note(1, "header", "foo bar a;lskdjf;alksjd;flkldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty and some additional info"),
    Note(1, "header", "foo bar a;lskdjf;alksjd;flkaa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty and some additional info"),
    Note(1, "header", "foo bar a;lskdjf;alksjd;flka;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty and some additional info"),
    Note(1, "header", "foo bar a;lskdjf;alksjd;flka;ldkjfa;sldkjfa;slkdjffa;lskdjf;alksfj;lsdkjfa;l baz qwerty and some additional info"),
    Note(1, "header", "foo bar baz qwerty and some  info"),
    Note(1, "header", "foo bar baz qwerty and some  info"),
    Note(1, "header", "foo bar baz qwerty and some  info"),
    Note(1, "header", "foo bar baz qwerty and some  info"),
    Note(1, "header", "foo bar baz qwerty and some additional info"),
  ];
}

final List<Color> _noteColors = [
  Color(0xffffffff), // classic white
  Color(0xfff28b81), // light pink
  Color(0xfffbf476), // light yellow
  Color(0xffcdff90), // light green
  Color(0xffa7feeb), // turquoise
  Color(0xffcbf0f8), // light cyan
  Color(0xffafcbfa), // light blue
];

class Note {
  int id;
  String title;
  String content;

  Note(this.id, this.title, this.content);
}

class NoteCard extends StatelessWidget {
  final Note note;
  final Color color;

  NoteCard({super.key, required this.note}) : color = _getRandomPastelColor(); // Инициализируем в конструкторе

  static Color _getRandomPastelColor() {
    return _noteColors[Random().nextInt(_noteColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ThemeService.noteBackground,
        borderRadius: BorderRadius.circular(8),
        border: BoxBorder.all(color: color),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(note.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            SizedBox(height: 8),
            Text(note.content, overflow: TextOverflow.ellipsis, maxLines: 10, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
