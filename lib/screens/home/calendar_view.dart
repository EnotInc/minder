import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

import '../../services/theme.dart';
import 'viewmodel.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  @override
  Widget build(BuildContext context) {
    EventsController controller = EventsController();
    List<Event> events = widget.viewModel.events;
    setState(() {
      controller.updateCalendarData((cd) {
        cd.clearAll();
        cd.addEvents(events);
      });
    });
    return SafeArea(
      child: Scaffold(
        // TODO: figure out how to notify users about notes
        body: EventsPlanner(
          controller: controller,
          daysShowed: 2,
          initialDate: DateTime.now(),
          maxPreviousDays: 2,
          dayParam: DayParam(
            dayEventBuilder: (event, height, width, heightPerMinute) {
              return Container(
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: ThemeService.mainBackground,
                  borderRadius: BorderRadius.circular(2),
                  border: BoxBorder.all(color: event.color, width: 2),
                ),
                child: DefaultDayEvent(
                  color: Colors.transparent,
                  height: height,
                  width: width,
                  title: event.title,
                  description: event.description,
                  onTap: () {
                    print('tap');
                    Navigator.of(context).pushNamed('/note_edit', arguments: {'note': event.data}).then((_) {
                      print('hello from list');
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
