import 'dart:async';

import 'package:app/screens/linear_survey_page.dart';
import 'package:app/screens/task_list.dart';
import 'package:app/src/notifications.dart';
import 'package:app/src/order.dart';
import 'package:app/src/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../data/data.dart';
import 'calender_page.dart';

getIDs() async {
  List<int> event = [];
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection(user).get();
  for (var element in querySnapshot.docs) {
    event.add(element['id']);
  }
  return event;
}
//ToDo: Save and reload Notification Time in SetPrefs.

startNotification() async {
  final NotificationService _notificationService = NotificationService();
  await _notificationService.zonedScheduleNotification(notificationTime);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final NotificationService _notificationService = NotificationService();

  bool _isButtonDisabled = DateTime.now().day == dayTask.day &&
          dayTask.month == DateTime.now().month ||
      getTask() == 30;

  late Timer timer;
  int _getTask = getTask();

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(const Duration(hours: 1), (Timer t) => updateStart());
    startNotification();
  }

  void updateStart() {
    if (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .difference(DateTime(dayTask.year, dayTask.month, dayTask.day))
            .inDays >
        0) {
      setState(() {
        _isButtonDisabled = false;
        _getTask = getTask();
      });
    }
  }

  void _disableButton() {
    setState(() {
      _isButtonDisabled = true;
    });
  }

  int test = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            'Secure Habits',
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "Today's Task:",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, right: 8.0, left: 8.0, bottom: 5),
                  child: Text(
                    _isButtonDisabled
                        ? 'There are no more tasks for you today, come again tomorrow'
                        : tasks[_getTask],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: OutlinedButton(
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16)),
                    onPressed: _isButtonDisabled
                        ? null
                        : () {
                      saveClick('instruction');
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Step-by-Step Instruction'),
                                content: SingleChildScrollView(
                                  child: _isButtonDisabled
                                      ? const Text('There is no description')
                                      : Text(inst[_getTask]),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                      );
                          },
                    child: const Text(
                      'Click here for the step-by-step guide!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),

              const Divider(
                color: Color(0xFFB2EBF2),
                thickness: 1.5,
                indent: 7.5,
                endIndent: 7.5,
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: TextButton(
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16)),
                    onPressed: () {
                      saveClick('viewList');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TaskList()));
                    },
                    child: const Text('View Finished Tasks')),
              ),

              const Divider(
                color: Color(0xFFB2EBF2),
                thickness: 1.5,
                indent: 7.5,
                endIndent: 7.5,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(children: [
                      CircularPercentIndicator(
                        radius: 30.0,
                        lineWidth: 5.0,
                        percent: 1.0,
                        center: Text(
                          cur.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        //FarbenCheck, unten nur 100-900 (1-9), anderes Scheme
                        progressColor: cur == 0
                            ? Colors.cyan[50]
                            : Colors.cyan[(cur * 100)],
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          (DateTime(DateTime.now().year, DateTime.now().month,
                                              DateTime.now().day)
                                          .difference(DateTime(startDate.year,
                                              startDate.month, startDate.day))
                                          .inDays +
                                      1)
                                  .toString() +
                              '/30',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Column(children: [
                      CircularPercentIndicator(
                        radius: 30.0,
                        lineWidth: 5.0,
                        //Change back to dates!
                        percent: (done /
                                    // Change to Dau + 1 and so!
                                    (DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day)
                                            .difference(DateTime(startDate.year,
                                                startDate.month, startDate.day))
                                            .inDays +
                                        1)) >
                                1.0
                            ? 1.0
                            : done /
                                (DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)
                                        .difference(DateTime(startDate.year,
                                            startDate.month, startDate.day))
                                        .inDays +
                                    1),
                        center: Text((done /
                                    (DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day)
                                            .difference(DateTime(startDate.year,
                                                startDate.month, startDate.day))
                                            .inDays +
                                        1) *
                                    100)
                                .toInt()
                                .toString() +
                            "%"),
                        progressColor: Colors.cyan,
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          (done * 1.50).toString() + '0€',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
              Row(
                children: const [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Streak',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Day',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Tasks",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Earned",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Color(0xFFB2EBF2),
                thickness: 1.5,
                indent: 7.5,
                endIndent: 7.5,
              ),
              CalendarPage(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _isButtonDisabled
              ? null
              : () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LinearSurveyPage(
                      callback: this._disableButton,
                      currentTask: _getTask)),
            );
          },
          label: const Text('Task Done'),
          icon: const Icon(Icons.check),
          backgroundColor: _isButtonDisabled ? Colors.grey : Colors.cyan,
        ),
      ),
    );
  }
}

class calcCurrStreak extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIDs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List temp = (snapshot.data as List);
          temp.sort();
          int curStreak = 1;
          int difference = DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .difference(
                  DateTime(startDate.year, startDate.month, startDate.day))
              .inDays;
          if (temp.isEmpty) {
            curStreak = 0;
          } else if (temp[temp.length - 1] < difference - 1) {
            curStreak = 0;
          } else {
            for (int i = temp.length - 1; i > 0; i--) {
              if (temp[i] - temp[i - 1] == 1) {
                curStreak++;
              } else {
                break;
              }
            }
          }
          int color = 50 * curStreak;
          return CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 5.0,
            percent: 1.0,
            center: Text(
              curStreak.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            progressColor: Colors.cyan[color],
          );
          // return Text(curStreak.toString());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class calcTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIDs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List temp = (snapshot.data as List);
          double perc = temp.length /
              (DateTime(DateTime.now().year, DateTime.now().month,
                          DateTime.now().day)
                      .difference(DateTime(
                          startDate.year, startDate.month, startDate.day))
                      .inDays +
                  1);
          return CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 5.0,
            percent: perc,
            center: Text((perc * 100).toInt().toString() + "%"),
            progressColor: Colors.cyan,
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
