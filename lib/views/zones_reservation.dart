import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: const BackButton(),
          title: const Text('Calendario'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SfCalendar(
            view: CalendarView.week,
            allowedViews: const [
              CalendarView.day,
              CalendarView.week,
              CalendarView.schedule
            ],
            timeSlotViewSettings:
                const TimeSlotViewSettings(timeInterval: Duration(hours: 2)),
          ),
        ));
  }
}
