import 'dart:async';

import 'package:client/api_modules/notesList/notesList.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

import '../../api_modules/body/body.dart';
import '../../api_modules/note/note.dart';
import '../../services/api.dart';
import '../../services/context.dart';
import '../../services/helper.dart';

class HomeViewModel with ChangeNotifier {
  List<Note> _notes = [];
  List<Event> _events = [];

  List<Note> get notes => _notes;

  set events(List<Event> data) {
    _events = data;
  }

  List<Event> get events {
    _events = notesAsEvents();
    return _events;
  }

  Future<void> fetchNotes() async {
    try {
      final Response<dynamic>? response = await ApiService().get(path: "notes");

      if (response != null) {
        final model = Body<Noteslist>.fromJson(response.data, (json) => Noteslist.fromJson(json as Map<String, dynamic>));

        if (model.success) {
          if (model.data != null) {
            _notes = model.data!.notes ?? [];
            _events = notesAsEvents();
            notifyListeners();
            return;
          }
        }
        throw (model.message ?? "unknown error");
      }
      throw ("unknown error");
    } catch (error) {
      HelperService().somethingWentWrong(error);
    }
  }

  void changeColor({required Color newColor, required Note note}) async {
    note.color = newColor;
    await changeNote(note);
    notifyListeners();
  }

  void askAboutDelete({required Note note}) {
    HelperService.alertDialog(
      title: Text("Information"),
      content: Text("Are you shoure you wanna delethe this note: '${note.title}'?"),
      buttons: [
        TextButton(
          onPressed: () async {
            await deleteNote(note: note);
            Navigator.of(ContextService.key.currentContext!).pop();
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
      HelperService().somethingWentWrong(error);
    }
  }

  Future<void> changeNote(Note note) async {
    try {
      final color = note.color.toHexString(includeHashSign: true, enableAlpha: false, toUpperCase: true).substring(2);
      Map<String, dynamic> body = {
        "note": {"note_id": note.id, "header": note.title, "text": note.description, "color": "#$color", "images": "", "is_notification": false, "is_important": note.isImportant},
      };
      final Response<dynamic>? response = await ApiService().post(path: "notes/edit", body: body);

      if (response != null) {
        final model = Body<Null>.fromJson(response.data, (json) => null);

        if (!model.success) {
          throw (model.message ?? "unable to edit note");
        }
        return;
      }
      throw ("unknown error");
    } catch (error) {
      HelperService().somethingWentWrong(error);
    }
  }

  Future<void> updateDate(Note note, DateTime date, bool repeat) async {
    try {
      Map<String, dynamic> body = {
        "note_id": note.id,
        "notification": {"notification_id": note.notification!.id, "date": date.toIso8601String(), "repeat": repeat},
      };

      final Response<dynamic>? response = await ApiService().post(path: "notes/notify/edit", body: body);
      if (response != null) {
        final model = Body<Null>.fromJson(response.data, (json) => null);

        if (model.success) {
          await fetchNotes();
        } else {
          throw ("Unable to load notes: ${model.message ?? "unknown error"}");
        }
      }
    } catch (error) {
      HelperService().somethingWentWrong(error);
    }
  }

  Future<void> deleteNotification(Note note) async {
    try {
      Map<String, dynamic> body = {"notification_id": note.notification!.id};
      final Response<dynamic>? response = await ApiService().delete(path: "notes/notify/delete", body: body);
      if (response != null) {
        final model = Body<Null>.fromJson(response.data, (json) => null);

        if (!model.success) {
          throw ("Unable to delete notification: ${model.message ?? "unknown error"}");
        }
        await fetchNotes();
      }
    } catch (error) {
      HelperService().somethingWentWrong(error);
    }
  }

  List<Event> notesAsEvents() {
    List<Event> events = _notes.where((note) => note.notification != null).map((note) {
      final t = note.notification!.remindAt;
      return Event(startTime: t, endTime: t.add(Duration(hours: 1)), title: note.title, description: note.description, color: note.color, data: note);
    }).toList();
    return events;
  }
}
