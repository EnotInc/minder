import 'package:client/api_modules/note.dart/note.dart';
import 'package:client/services/context.dart';
import 'package:client/services/helper.dart';
import 'package:flutter/material.dart';

import '../../services/color.dart';

class NoteEditViewModel extends ChangeNotifier {
  Note? _note;

  Note? get note => _note;

  //NOTE: when it's true and user is exiting the screen - create a new note in db
  bool isNew = false;

  DateTime? selectedDate;

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
    // TODO: implement
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
    // TODO: implement
  }

  Future<void> changeNote() async {
    // TODO: implement
  }
}
