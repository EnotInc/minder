import 'package:client/services/theme.dart';
import 'package:flutter/material.dart';

import '../api_modules/note.dart/note.dart';

class DateService {
  static Widget dateSeting({required Note note}) {
    return DateSettingAlert(note: note);
  }
}

class DateSettingAlert extends StatefulWidget {
  const DateSettingAlert({super.key, required this.note});

  final Note note;

  @override
  State<DateSettingAlert> createState() => _DateSettingAlertState();
}

class _DateSettingAlertState extends State<DateSettingAlert> {
  DateTime fooDate = DateTime.now();
  TimeOfDay fooTime = TimeOfDay.now();
  bool _switch = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: widget.note.color!, width: 4.0),
        color: ThemeService.mainBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Row(
                  spacing: 8,
                  children: [
                    const Icon(Icons.edit_calendar_outlined),
                    Text("${fooDate.month}.${fooDate.day}", style: const TextStyle(fontSize: 16.0)),
                  ],
                ),
                onPressed: () async {
                  final newDate =
                      await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2036), initialDate: DateTime.now()) ?? DateTime(3333, 11, 11);
                  setState(() {
                    fooDate = newDate;
                  });
                },
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () async {
                  final newTime = await showTimePicker(context: context, initialTime: TimeOfDay.now()) ?? TimeOfDay.now();
                  setState(() {
                    fooTime = newTime;
                  });
                },
                child: Row(
                  spacing: 8,
                  children: [
                    const Icon(Icons.access_time_outlined),
                    Text(" ${fooTime.hour}:${fooTime.minute} ", style: const TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Ежедневно: "),
              Switch(
                value: _switch,
                onChanged: (value) {
                  setState(() {
                    _switch = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Ок"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Отмена"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
