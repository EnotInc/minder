import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api_modules/note.dart/note.dart';
import '../../services/api.dart';
import '../../services/context.dart';
import '../../services/helper.dart';

class HomeViewModel with ChangeNotifier {
  final List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> fetchNotes() async {
    try {
      final Response<dynamic>? response = await ApiService().get(path: "notes");
      print('foo');
      if (response != null) {
        print('bar');
      }
      print('baz');
    } catch (error) {
      print(error);
    }
  }

  void changeColor({required Color newColor, required Note note}) {
    final note0 = _notes.firstWhere((n) => n.id == note.id);
    note0.color = newColor;
    notifyListeners();
  }

  void askAboutDelete({required Note note}) {
    HelperService.alertDialog(
      title: Text("Информация"),
      content: Text("Вы уверены что хотите удалить заметку '${note.title}'?"),
      buttons: [
        TextButton(
          onPressed: () async {
            await deleteNote(note: note);
            Navigator.of(ContextService.key.currentContext!).popUntil((route) => route.settings.name == '/home');
          },
          child: Text("Да"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ContextService.key.currentContext!).pop();
          },
          child: Text("Нет"),
        ),
      ],
    );
  }

  Future<void> deleteNote({required Note note}) async {
    _notes.remove(note);
    notifyListeners();
  }
}
