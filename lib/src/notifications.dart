import 'package:app/src/widgets.dart';
import 'package:flutter/src/material/time.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> init() async {
    //Initialization Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    //Initialization Settings for iOS
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    saveClick(
        notificationAppLaunchDetails?.didNotificationLaunchApp.toString());

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    // onSelectNotification: selectNotification);

  }

  //ToDO: Time-Dependant Notifications!
  Future<void> zonedScheduleNotification(TimeOfDay notificationTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Secure Habits',
        'Do not forget to do the daily task',
        _nextInstanceOfNotification(notificationTime),
        const NotificationDetails(
            android: AndroidNotificationDetails('1', 'Secure Habits Reminder',
                channelDescription: 'Reminder for Secure Habits App')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

// //Remove Trash
// Future<void> showNotification() async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//   AndroidNotificationDetails('your channel id', 'your channel name',
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker');
//   const NotificationDetails platformChannelSpecifics =
//   NotificationDetails(android: androidPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//       0, 'plain title', 'plain body', platformChannelSpecifics,
//       payload: 'item x');
// }
}

//ToDo: Timezone is somehow UTC and not locale? - Do I really care?
tz.TZDateTime _nextInstanceOfNotification(TimeOfDay notificationTime) {
  // tz.setLocalLocation(tz.getLocation(timeZoneName!));
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
      now.day, notificationTime.hour, notificationTime.minute);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

