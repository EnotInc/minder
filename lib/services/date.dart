import 'package:client/services/context.dart';
import 'package:client/services/theme.dart';
import 'package:flutter/material.dart';

import '../api_modules/note/note.dart';

class DateService {
  static Widget dateSeting({required Note note, required Function onAdd, required Function onDelete}) {
    return DateSettingAlert(note: note, onAdd: onAdd, onDelete: onDelete);
  }
}

class DateSettingAlert extends StatefulWidget {
  const DateSettingAlert({super.key, required this.note, required this.onAdd, required this.onDelete});

  final Note note;
  final Function onAdd;
  final Function onDelete;

  @override
  State<DateSettingAlert> createState() => _DateSettingAlertState();
}

class _DateSettingAlertState extends State<DateSettingAlert> {
  bool repeat = false;
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = widget.note.notification?.remindAt ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: widget.note.color, width: 4.0),
        color: ThemeService.mainBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Text("Notification"),
            actions: [
              IconButton(
                icon: Icon(Icons.delete_forever_outlined),
                onPressed: () {
                  widget.onDelete(widget.note);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          TextButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Icon(Icons.access_time_outlined),
                Text(" ${date.hour}:${date.minute} ", style: const TextStyle(fontSize: 16.0)),
              ],
            ),
            onPressed: () async {
              final newTime =
                  await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: date.hour, minute: date.minute),
                  ) ??
                  TimeOfDay.now();
              setState(() {
                date = date.copyWith(year: date.year, month: date.month, day: date.day, hour: newTime.hour, minute: newTime.minute, second: 0, millisecond: 0, microsecond: 0);
              });
            },
          ),
          //const SizedBox(width: 12),
          TextButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Icon(Icons.edit_calendar_outlined),
                Text("${date.year} ${date.month} ${date.day}", style: const TextStyle(fontSize: 16.0)),
              ],
            ),
            onPressed: () async {
              final newDate = await showDatePicker(context: context, firstDate: date, lastDate: DateTime(2036), initialDate: DateTime.now()) ?? DateTime(3333, 11, 11);
              setState(() {
                date = date.copyWith(
                  year: newDate.year,
                  month: newDate.month,
                  day: newDate.day,
                  hour: date.hour,
                  minute: date.minute,
                  second: date.second,
                  millisecond: date.millisecond,
                  microsecond: date.microsecond,
                );
              });
            },
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text("Repeat daily: "),
          //     Switch(
          //       value: _switch,
          //       onChanged: (value) {
          //         setState(() {
          //           _switch = value;
          //         });
          //       },
          //     ),
          //   ],
          // ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  widget.onAdd(widget.note, date, repeat);
                  Navigator.of(ContextService.key.currentContext!).pop();
                },
                child: const Text("Ok"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
