import 'package:client/api_modules/note/note.dart';
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
  EventsController controller = EventsController();
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEvents();
    });
    widget.viewModel.addListener(_loadEvents);
    _loadEvents();
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.removeListener(_loadEvents);
  }

  Future<void> _loadEvents() async {
    if (mounted) {
      events = widget.viewModel.events;
      controller.updateCalendarData((cd) {
        cd.clearAll();
        cd.addEvents(events);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ThemeService.mainBackground,
        drawerScrimColor: ThemeService.mainBackground,
        body: EventsPlanner(
          controller: controller,
          daysShowed: 1,
          initialDate: DateTime.now(),
          maxPreviousDays: 2,
          daysHeaderParam: DaysHeaderParam(daysHeaderForegroundColor: Colors.white),
          offTimesParam: OffTimesParam(offTimesColor: ThemeService.mainBackground),
          dayParam: DayParam(
            todayColor: ThemeService.secondBackground,
            dayColor: ThemeService.mainBackground,
            dayEventBuilder: (event, height, width, heightPerMinute) {
              bool imortant = false;
              if (event.data is Note) {
                final obj = event.data as Note;
                imortant = obj.isImportant;
              }
              return Container(
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: ThemeService.mainBackground,
                  borderRadius: BorderRadius.circular(2),
                  border: BoxBorder.all(color: event.color, width: imortant ? 3 : 1),
                ),
                child: DefaultDayEvent(
                  color: ThemeService.mainBackground,
                  height: height,
                  width: width,
                  title: event.title,
                  description: event.description,
                  onTap: () {
                    print('tap');
                    Navigator.of(context).pushNamed('/note_edit', arguments: {'note': event.data}).then((_) async {
                      setState(() async {
                        events = widget.viewModel.events;
                        controller.updateCalendarData((cd) {
                          cd.clearAll();
                          cd.addEvents(events);
                        });
                      });
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
