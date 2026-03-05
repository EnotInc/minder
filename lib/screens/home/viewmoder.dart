import 'package:client/api_modules/notesList/notesList.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api_modules/body/body.dart';
import '../../api_modules/note.dart/note.dart';
import '../../services/api.dart';
import '../../services/context.dart';
import '../../services/helper.dart';

class HomeViewModel with ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> fetchNotes() async {
    try {
      final Response<dynamic>? response = await ApiService().get(path: "notes");

      if (response != null) {
        final model = Body<Noteslist>.fromJson(response.data, (json) => Noteslist.fromJson(json as Map<String, dynamic>));

        if (model.success) {
          if (model.data != null) {
            _notes = model.data!.notes ?? [];
          }
        }
      }
      notifyListeners();
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
    //TODO: reimplement
    _notes.remove(note);
    notifyListeners();
  }
}
