
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;


class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();
  // FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  Future requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      // print('Notification permission granted');
      // Now you can schedule notifications
    } else {
      // print('Notification permission denied');
      // Handle denied permission
    }
  }

  static init() {
    _notification.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    tz.initializeTimeZones();
  }
//-------------------working code------------without repeat logic

  // static void scheduleNotification(String title, String body, bool repeatOnDays,
  //     DateTime scheduledDateTime) async {
  //   // Get the current date and time
  //   DateTime now = DateTime.now();

  //   // Check if the scheduledDateTime is in the past
  //   if (scheduledDateTime.isBefore(now)) {
  //     // If so, adjust it to be in the future
  //     scheduledDateTime = now.add(
  //        const  Duration(seconds: 1)); // Add a second to ensure it's in the future
  //   }

  //   var androidDetails = const AndroidNotificationDetails(
  //       'important_notification', 'My Channel',
  //       importance: Importance.max, priority: Priority.high);
  //   var iosDetail = const DarwinNotificationDetails();
  //   var notificationDetails =
  //       NotificationDetails(android: androidDetails, iOS: iosDetail);

  //   await _notification.zonedSchedule(
  //     0,
  //     title,
  //     body,
  //     tz.TZDateTime.from(scheduledDateTime, tz.local),
  //     notificationDetails,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //   );
  // }


///////////////////////////////////////------------------------working code
  // static sheduleAlarmNotification(
  //     DateTime datetim, int randomnumber, String title, String body) async {
  //   int newtime =
  //       datetim.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
  //   // print(datetim.millisecondsSinceEpoch);
  //   // print(DateTime.now().millisecondsSinceEpoch);
  //   // print(newtime);
  //   await _notification.zonedSchedule(
  //       randomnumber,
  //       title,
  //       body,
  //       tz.TZDateTime.now(tz.local).add(Duration(milliseconds: newtime)),
  //       const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //               'important_notification', 'My Channel',
  //               // channelDescription: 'your channel description',
  //               sound: RawResourceAndroidNotificationSound("alarm"),
  //               autoCancel: false,
  //               playSound: true,
  //               priority: Priority.max),
  //           iOS: DarwinNotificationDetails(presentSound: true)),
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime);
  // }

   void scheduleNotification(String title, String body, bool repeatOnDays,
      DateTime scheduledDateTime, List<String> selectedDays,int randomnumber,) async {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Check if the scheduledDateTime is in the past
    if (scheduledDateTime.isBefore(now)) {
      // If so, adjust it to be in the future
      scheduledDateTime = now.add(
          Duration(seconds: 1)); // Add a second to ensure it's in the future
    }

    var androidDetails = const AndroidNotificationDetails(
      'important_notification',
      'My Channel',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );
    var iosDetails = const DarwinNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    if (repeatOnDays && selectedDays.isNotEmpty) {
      // Schedule notifications for selected days
      for (String day in selectedDays) {
        int dayOfWeek = _getDayOfWeekIndex(day);
        int dayDifference = (dayOfWeek - scheduledDateTime.weekday + 7) % 7;
        DateTime scheduledDayDateTime =
            scheduledDateTime.add(Duration(days: dayDifference));

        await _notification.zonedSchedule(
          randomnumber,
          title,
          body,
          tz.TZDateTime.from(scheduledDayDateTime, tz.local),
          platformChannelSpecifics,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    } else {
      // Schedule a single notification
      await _notification.zonedSchedule(
        randomnumber,
        title,
        body,
        tz.TZDateTime.from(scheduledDateTime, tz.local),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  void scheduleAlarmNotification(String title, String body, bool repeatOnDays,
      DateTime scheduledDateTime, List<String> selectedDays,int randomnumber,) async {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Check if the scheduledDateTime is in the past
    if (scheduledDateTime.isBefore(now)) {
      // If so, adjust it to be in the future
      scheduledDateTime = now.add(
          Duration(seconds: 1)); // Add a second to ensure it's in the future
    }

    var androidDetails = const AndroidNotificationDetails(
      'important_notification',
      'My Channel',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound("alarm"),
                autoCancel: false,
                playSound: true,
       enableVibration: true,
      enableLights: true,
    );
    var iosDetails = const DarwinNotificationDetails(presentSound: true);
    var platformChannelSpecifics =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    if (repeatOnDays && selectedDays.isNotEmpty) {
      // Schedule notifications for selected days
      for (String day in selectedDays) {
        int dayOfWeek = _getDayOfWeekIndex(day);
        int dayDifference = (dayOfWeek - scheduledDateTime.weekday + 7) % 7;
        DateTime scheduledDayDateTime =
            scheduledDateTime.add(Duration(days: dayDifference));

        await _notification.zonedSchedule(
          randomnumber,
          title,
          body,
          tz.TZDateTime.from(scheduledDayDateTime, tz.local),
          
          platformChannelSpecifics,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    } else {
      // Schedule a single notification
      await _notification.zonedSchedule(
        randomnumber,
        title,
        body,
        tz.TZDateTime.from(scheduledDateTime, tz.local),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  static void cancelNotification(int notificationId) async {
    await _notification.cancel(notificationId);
  }

  int _getDayOfWeekIndex(String day) {
    switch (day) {
      case 'Sunday':
        return DateTime.sunday;
      case 'Monday':
        return DateTime.monday;
      case 'Tuesday':
        return DateTime.tuesday;
      case 'Wednesday':
        return DateTime.wednesday;
      case 'Thursday':
        return DateTime.thursday;
      case 'Friday':
        return DateTime.friday;
      case 'Saturday':
        return DateTime.saturday;
      default:
        throw Exception('Invalid day of the week: $day');
    }
  }
}