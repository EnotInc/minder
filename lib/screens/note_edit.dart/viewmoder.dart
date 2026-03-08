import 'package:client/api_modules/note.dart/note.dart';
import 'package:client/services/context.dart';
import 'package:client/services/helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../api_modules/body/body.dart';
import '../../services/api.dart';

class NoteEditViewModel extends ChangeNotifier {
  late Note note;

  //NOTE: when it's true and user is exiting the screen - create a new note in db
  bool isNew = false;

  DateTime? selectedDate;

  void changeColor({required Color newColor}) {
    note.color = newColor;
    notifyListeners();
  }

  void changeImportant() {
    note.isImportant = !note.isImportant;
    notifyListeners();
  }

  void askAboutGoBack() {
    HelperService.alertDialog(
      title: Text('Внимание!'),
      content: Text('Вы уверены что хотите выйти? Изменения не будут сохранены'),
      buttons: [
        TextButton(
          onPressed: () async {
            if (!isNew) {
              await deleteNote();
            }
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

  Future<void> selectDate() async {
    selectedDate = await showDatePicker(context: ContextService.key.currentContext!, firstDate: DateTime.now(), lastDate: DateTime(2036), initialDate: DateTime.now());
  }

  void askAboutDelete() {
    HelperService.alertDialog(
      title: Text("Информация"),
      content: Text("Вы уверены что хотите удалить заметку?"),
      buttons: [
        TextButton(
          onPressed: () async {
            if (!isNew) {
              await deleteNote();
            }
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

  Future<void> deleteNote() async {
    try {
      // TODO: test after null note fix
      Map<String, dynamic> body = {"note_id": note.id};
      final Response<dynamic>? response = await ApiService().delete(path: "notes/delete", body: body);

      if (response != null) {
        final model = Body<Null>.fromJson(response.data, (json) => null);
        if (model.success) {
          Navigator.of(ContextService.key.currentContext!).pop();
          notifyListeners();
          return;
        }
        throw (model.message ?? "unknown error");
      }
    } catch (error) {
      ApiService().somethingWentWrong(error);
    }
  }

  Future<void> completeNote() async {
    switch (isNew) {
      case true:
        await createNote();
      case false:
        await changeNote();
    }
  }

  Future<void> createNote() async {
    try {
      final color = note.color.toHexString(includeHashSign: true, enableAlpha: false, toUpperCase: true).substring(2);
      Map<String, dynamic> body = {
        "note": {"header": note.title, "text": note.description, "color": "#$color", "images": "", "is_notification": false, "is_important": note.isImportant},
      };
      final Response<dynamic>? response = await ApiService().post(path: "notes/add", body: body);

      if (response != null) {
        final model = Body<Null>.fromJson(response.data, (json) => null);

        if (model.success) {
          Navigator.of(ContextService.key.currentContext!).pop();
          return;
        }
        throw (model.message ?? "unknown error");
      }
    } catch (error) {
      ApiService().somethingWentWrong(error);
    }
  }

  Future<void> changeNote() async {
    // TODO: implement
  }
}
