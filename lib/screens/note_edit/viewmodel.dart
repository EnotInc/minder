import 'package:client/api_modules/note/note.dart';
import 'package:client/services/context.dart';
import 'package:client/services/helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../api_modules/notification/notification.dart';
import '../../api_modules/body/body.dart';
import '../../services/api.dart';

class NoteEditViewModel extends ChangeNotifier {
  late Note note;

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
      title: Text('Attettion!'),
      content: Text('Are you shoure you wanna leave? Unsaved changes will be lost'),
      buttons: [
        TextButton(
          onPressed: () async {
            Navigator.of(ContextService.key.currentContext!).popUntil((route) => route.settings.name == '/home');
          },
          child: Text("Yes"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ContextService.key.currentContext!).pop();
          },
          child: Text("No"),
        ),
      ],
    );
  }

  Future<void> selectDate() async {
    selectedDate = await showDatePicker(context: ContextService.key.currentContext!, firstDate: DateTime.now(), lastDate: DateTime(2036), initialDate: DateTime.now());
  }

  void askAboutDelete() {
    HelperService.alertDialog(
      title: Text("Information"),
      content: Text("Are you shoure you wanna delete this note?"),
      buttons: [
        TextButton(
          onPressed: () async {
            Navigator.of(ContextService.key.currentContext!).pop();
            await deleteNote();
          },
          child: Text("Yes"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ContextService.key.currentContext!).pop();
          },
          child: Text("No"),
        ),
      ],
    );
  }

  Future<void> deleteNote() async {
    try {
      Map<String, dynamic> body = {"note_id": note.id};
      final Response<dynamic>? response = await ApiService().delete(path: "notes/delete", body: body);

      if (response != null) {
        final model = Body<Null>.fromJson(response.data, (json) => null);
        if (model.success) {
          Navigator.of(ContextService.key.currentContext!).pop();
          return;
        } else {
          throw (model.message ?? "unknown error");
        }
      }
      throw ("unknown error");
    } catch (error) {
      HelperService().somethingWentWrong(error);
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
      Map<String, dynamic> notify = {"date": note.notification?.remindAt.toIso8601String(), "repeat": false};
      if (note.notification == null) {
        notify = {};
      }
      Map<String, dynamic> body = {
        "note": {"header": note.title, "text": note.description, "color": "#$color", "images": "", "is_important": note.isImportant},
        "notification": note.notification != null ? notify : null,
      };
      final Response<dynamic>? response = await ApiService().post(path: "notes/add", body: body);

      if (response != null) {
        final model = Body<Null>.fromJson(response.data, (json) => null);

        if (model.success) {
          Navigator.of(ContextService.key.currentContext!).pop();
          return;
        }
        throw (model.message ?? "unable to create note");
      }
      throw ("unknown error");
    } catch (error) {
      HelperService().somethingWentWrong(error);
    }
  }

  Future<void> changeNote() async {
    try {
      final color = note.color.toHexString(includeHashSign: true, enableAlpha: false, toUpperCase: true).substring(2);
      Map<String, dynamic> notify = {"date": note.notification?.remindAt.toIso8601String(), "repeat": false};
      if (note.notification == null) {
        notify = {};
      }
      Map<String, dynamic> body = {
        "note": {"note_id": note.id, "header": note.title, "text": note.description, "color": "#$color", "images": "", "is_important": note.isImportant},
        "notification": note.notification != null ? notify : null,
      };
      final Response<dynamic>? response = await ApiService().post(path: "notes/edit", body: body);

      if (response != null) {
        final model = Body<Null>.fromJson(response.data, (json) => null);

        if (model.success) {
          Navigator.of(ContextService.key.currentContext!).pop();
          return;
        }
        throw (model.message ?? "unable to edit note");
      }
      throw ("unknown error");
    } catch (error) {
      HelperService().somethingWentWrong(error);
    }
  }

  void addDate(Note note, DateTime date, bool repeat) async {
    note.notification = Notification(id: -1, remindAt: date, isSent: false);
    try {
      if (!isNew && note.id != -1) {
        Map<String, dynamic> notify = {"date": note.notification?.remindAt.toIso8601String(), "repeat": false};
        Map<String, dynamic> body = {"note_id": note.id, "notification": notify};

        final Response<dynamic>? response = await ApiService().post(path: "notes/notify/add", body: body);

        if (response != null) {
          final model = Body<Null>.fromJson(response.data, (json) => null);

          if (!model.success) {
            throw ("Cannot add notification: ${model.message ?? "unknown error"}");
          }
        }
      }
    } catch (error) {
      HelperService().somethingWentWrong(error);
    }
    notifyListeners();
  }

  Future<void> editDate(Note note, DateTime date, bool repeat) async {
    try {
      final dateWithoutTimezone = date.toIso8601String().split("Z").first;
      Map<String, dynamic> body = {
        "note_id": note.id,
        "notification": {"notification_id": note.notification!.id, "date": dateWithoutTimezone, "repeat": repeat},
      };

      final Response<dynamic>? response = await ApiService().post(path: "notes/notify/edit", body: body);
      if (response != null) {
        final model = Body<Null>.fromJson(response.data, (json) => null);

        if (!model.success) {
          throw ("Unable to change the date: ${model.message ?? "unknown error"}");
        }

        note.notification!.remindAt = date;
      }
      notifyListeners();
    } catch (error) {
      HelperService().somethingWentWrong(error);
    }
  }

  Future<void> deleteNotification(Note _) async {
    if (isNew || note.notification!.id == -1) {
      note.notification = null;
      notifyListeners();
      return;
    }
    try {
      Map<String, dynamic> body = {"notification_id": note.notification!.id};
      final Response<dynamic>? response = await ApiService().delete(path: "notes/notify/delete", body: body);
      if (response != null) {
        final model = Body<Null>.fromJson(response.data, (json) => null);
        if (!model.success) {
          throw ("Unable to delete note: ${model.message ?? "unknown error"}");
        }
      }
      note.notification = null;
    } catch (error) {
      HelperService().somethingWentWrong(error);
    }
    notifyListeners();
  }
}
