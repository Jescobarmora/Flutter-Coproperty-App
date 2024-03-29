import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class LoadDataFromFireStore extends StatefulWidget {
  const LoadDataFromFireStore({Key? key}) : super(key: key);

  @override
  LoadDataFromFireStoreState createState() => LoadDataFromFireStoreState();
}

class LoadDataFromFireStoreState extends State<LoadDataFromFireStore> {
  final List<Color> _colorCollection = <Color>[];
  MeetingDataSource? events;
  final List<String> options = <String>['Add', 'Delete', 'Update'];
  final fireStoreReference = FirebaseFirestore.instance;
  bool isInitialLoaded = false;

  @override
  void initState() {
    _initializeEventColor();
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    fireStoreReference
        .collection("CalendarAppointmentCollection")
        .snapshots()
        .listen((event) {
      for (var element in event.docChanges) {
        if (element.type == DocumentChangeType.added) {
          if (!isInitialLoaded) {
            continue;
          }

          final Random random = Random();
          Meeting app = Meeting.fromFireBaseSnapShotData(
              element, _colorCollection[random.nextInt(9)]);
          setState(() {
            events!.appointments!.add(app);
            events!.notifyListeners(CalendarDataSourceAction.add, [app]);
          });
        } else if (element.type == DocumentChangeType.modified) {
          if (!isInitialLoaded) {
            continue;
          }

          final Random random = Random();
          Meeting app = Meeting.fromFireBaseSnapShotData(
              element, _colorCollection[random.nextInt(9)]);
          setState(() {
            int index = events!.appointments!
                .indexWhere((app) => app.key == element.doc.id);

            Meeting meeting = events!.appointments![index];

            events!.appointments!.remove(meeting);
            events!.notifyListeners(CalendarDataSourceAction.remove, [meeting]);
            events!.appointments!.add(app);
            events!.notifyListeners(CalendarDataSourceAction.add, [app]);
          });
        } else if (element.type == DocumentChangeType.removed) {
          if (!isInitialLoaded) {
            continue;
          }

          setState(() {
            int index = events!.appointments!
                .indexWhere((app) => app.key == element.doc.id);

            Meeting meeting = events!.appointments![index];
            events!.appointments!.remove(meeting);
            events!.notifyListeners(CalendarDataSourceAction.remove, [meeting]);
          });
        }
      }
    });
    super.initState();
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await fireStoreReference
        .collection("CalendarAppointmentCollection")
        .get();

    final Random random = Random();
    List<Meeting> list = snapShotsValue.docs
        .map((e) => Meeting(
            eventName: e.data()['Subject'],
            from:
                DateFormat('dd/MM/yyyy HH:mm:ss').parse(e.data()['StartTime']),
            to: DateFormat('dd/MM/yyyy HH:mm:ss').parse(e.data()['EndTime']),
            background: _colorCollection[random.nextInt(9)],
            isAllDay: false,
            key: e.id))
        .toList();
    setState(() {
      events = MeetingDataSource(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    isInitialLoaded = true;
    return Scaffold(
        appBar: AppBar(
            leading: PopupMenuButton<String>(
          icon: const Icon(Icons.settings),
          itemBuilder: (BuildContext context) => options.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList(),
          onSelected: (String value) {
            if (value == 'Add') {
              fireStoreReference
                  .collection("CalendarAppointmentCollection")
                  .doc("1")
                  .set({
                'Subject': 'Mastering Flutter',
                'StartTime': '07/06/2020 08:00:00',
                'EndTime': '07/06/2020 09:00:00'
              });
            } else if (value == "Delete") {
              try {
                fireStoreReference
                    .collection('CalendarAppointmentCollection')
                    .doc('1')
                    .delete();
              } catch (e) {}
            } else if (value == "Update") {
              try {
                fireStoreReference
                    .collection('CalendarAppointmentCollection')
                    .doc('1')
                    .update({'Subject': 'Meeting'});
              } catch (e) {}
            }
          },
        )),
        body: SfCalendar(
          view: CalendarView.month,
          initialDisplayDate: DateTime(2022, 6, 4, 9, 0, 0),
          dataSource: events,
          monthViewSettings: const MonthViewSettings(
            showAgenda: true,
          ),
        ));
  }

  void _initializeEventColor() {
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}

class Meeting {
  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
  String? key;

  Meeting(
      {this.eventName,
      this.from,
      this.to,
      this.background,
      this.isAllDay,
      this.key});

  static Meeting fromFireBaseSnapShotData(dynamic element, Color color) {
    return Meeting(
        eventName: element.doc.data()!['Subject'],
        from: DateFormat('dd/MM/yyyy HH:mm:ss')
            .parse(element.doc.data()!['StartTime']),
        to: DateFormat('dd/MM/yyyy HH:mm:ss')
            .parse(element.doc.data()!['EndTime']),
        background: color,
        isAllDay: false,
        key: element.doc.id);
  }
}
