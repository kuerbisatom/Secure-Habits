import 'package:app/data/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime kToday = DateTime.now();
DateTime kFirstDay = startDate;
DateTime kLastDay = startDate.add(const Duration(days: 30));

String user = FirebaseAuth.instance.currentUser!.uid;

getDates() async {
  List<DateTime> event = [];
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection(user).get();
  for (var element in querySnapshot.docs) {
    event.add(DateTime.fromMicrosecondsSinceEpoch(
        element['timestamp'].microsecondsSinceEpoch));
  }
  return event;
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPage createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {
  late final PageController _pageController;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());

  final CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDates(),
      builder: (context, snapshot) {
        // if (snapshot.hasData) {
        return Column(
          children: [
            ValueListenableBuilder<DateTime>(
              valueListenable: _focusedDay,
              builder: (context, value, _) {
                return _CalendarHeader(
                  focusedDay: value,
                  clearButtonVisible: false,
                  onTodayButtonTap: () {
                    setState(() => _focusedDay.value = DateTime.now());
                  },
                  onClearButtonTap: () {},
                  onLeftArrowTap: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                  onRightArrowTap: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                );
              },
            ),
            TableCalendar(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay.value,
              headerVisible: false,
              calendarFormat: _calendarFormat,
              holidayPredicate: (day) {
                if (snapshot.hasData) {
                  for (var x in (snapshot.data as List)) {
                    if (day.day == x.day && day.month == x.month) {
                      return true;
                    }
                  }
                }
                return false;
              },
              onCalendarCreated: (controller) => _pageController = controller,
              onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
              calendarBuilders: CalendarBuilders(
                holidayBuilder: (context, day, focusedDay) {
                  return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Center(
                            child: Text(day.day.toString()),
                          ),
                          Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.cyan.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ));
                },
                todayBuilder: (context, day, focusedDay) {
                  if (dayTask.month == day.month && dayTask.day == day.day) {
                    return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Center(
                              child: Text(day.day.toString()),
                            ),
                            Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.cyan.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ));
                  } else {
                    return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                  decoration: const BoxDecoration(
                                color: Colors.cyan,
                                shape: BoxShape.circle,
                              )),
                            ),
                            Center(
                              child: Text(
                                day.day.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ));
                  }
                },
              ),
              calendarStyle: const CalendarStyle(
                holidayTextStyle: TextStyle(color: Colors.black),
                holidayDecoration: BoxDecoration(
                  color: Colors.lightGreenAccent,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.cyan,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
          ],
        );
        // } else {
        //   return const Text("Loading");
        // }
      },
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final bool clearButtonVisible;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onClearButtonTap,
    required this.clearButtonVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 120.0,
            child: Text(
              headerText,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }
}
