import 'package:app/screens/home.dart';
import 'package:app/screens/task_list.dart';
import 'package:app/src/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/data.dart';
import 'firebase_options.dart';
import 'screens/on_boarding_2.dart';

bool isViewed = true;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final NotificationService _notificationService = NotificationService();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getBool('boarding') ?? true;
  String? temp = prefs.getString('startDate');
  if (temp != null) {
    startDate = DateTime.parse(temp);
  } else {
    startDate = DateTime.now();
  }
  //Probably set day -1 (corrects grey problem?)
  temp = prefs.getString('date');
  if (temp != null) {
    dayTask = DateTime.parse(temp);
  } else {
    DateTime.now().subtract(const Duration(days: 1));
  }
  int? t_curr = prefs.getInt('cur');
  if (t_curr != null) {
    if (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .difference(DateTime(dayTask.year, dayTask.month, dayTask.day))
            .inDays >
        1) {
      cur = 0;
    } else {
      cur = t_curr;
    }
  } else {
    cur = 0;
  }

  t_curr = prefs.getInt('done');
  if (t_curr != null) {
    done = t_curr;
  } else {
    done = 0;
  }

  List<String>? ft_curr = prefs.getStringList('tasks');
  if (ft_curr != null) {
    finishedTasks = ft_curr;
  } else {
    finishedTasks = [];
  }
  List<String>? notiTime = prefs.getStringList('notiTime');
  if (notiTime != null) {
    notificationTime =
        TimeOfDay(hour: int.parse(notiTime[0]), minute: int.parse(notiTime[1]));
  } else {
    notificationTime = const TimeOfDay(hour: 18, minute: 00);
  }

  if (!isViewed) {
    await _notificationService.zonedScheduleNotification(notificationTime);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool finished = DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .difference(DateTime(startDate.year, startDate.month, startDate.day))
          .inDays >
      29;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure Habits',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      // home: OnBoardingPage(),
      home: finished
          ? Finished()
          : isViewed
              ? OnBoardingPage()
              : const HomePage(title: 'Secure Habits'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Finished extends StatelessWidget {
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
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'User Study Finished!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 50),
                        ),
                        Text(
                          '\n\nYou earned in total: ' +
                              (done * 1.5).toString() +
                              '0€',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        const Text(
                          '\n\nPlease fill out the survey: \n',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        const TextButton(
                          onPressed: _launchURL,
                          child: Text(
                            'https://www.unipark.de/uc/secure_habits/',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  fixedSize: const Size(300, 75)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TaskList()));
                              },
                              child: const Text(
                                'Revisiting all Tasks',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )),
                        )
                      ],
                    )))));
  }
}

void _launchURL() async {
  String _url = 'https://www.unipark.de/uc/secure_habits/';
  if (!await launch(_url)) throw 'Could not launch $_url';
}