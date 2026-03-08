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
            notifyListeners();
            return;
          }
        }
        throw (model.message ?? "unknown error");
      }
      throw ("unknown error");
    } catch (error) {
      ApiService().somethingWentWrong(error);
    }
  }

  void changeColor({required Color newColor, required Note note}) {
    // TODO: implement note edit
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
            Navigator.of(ContextService.key.currentContext!).pop();
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
    try {
      Map<String, dynamic> body = {"note_id": note.id};
      final Response<dynamic>? response = await ApiService().delete(path: "notes/delete", body: body);

      if (response != null) {
        final model = Body<Null>.fromJson(response.data, (json) => null);
        if (model.success) {
          fetchNotes();
          return;
        }
        throw (model.message ?? "unknown error");
      }
      notifyListeners();
    } catch (error) {
      ApiService().somethingWentWrong(error);
    }
  }
}
