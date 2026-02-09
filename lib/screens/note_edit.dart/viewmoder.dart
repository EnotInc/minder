import 'package:client/api_modules/note.dart/note.dart';
import 'package:flutter/material.dart';

import '../../services/color.dart';

class NoteEditViewModel extends ChangeNotifier {
  Note? _note;

  Note? get note => _note;

  set note(Note value) {
    _note = value;
  }

  void changeColor({required Color newColor}) {
    _note!.color = newColor;
    notifyListeners();
  }

  Future<Note> makeNewNote() async {
    final n = Note(id: 1, title: "foo", content: "", color: ColorService.getRandomPastelColor());
    return n;
  }

  Future<void> createNote() async {}
}
