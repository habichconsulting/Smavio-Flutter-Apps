// /LocalNotification Service for display notification

import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
          iOS: IOSInitializationSettings(),
            android: AndroidInitializationSettings("@mipmap/launcher_icon"));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      if (route != null) {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        // Navigator.of(context).push(context,MaterialPageRoute(builder: (context)=>);
      }
    });
  }

  static void display({required String title, required String body}) async {
    try {
      log('on display');
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // ignore: prefer_const_declarations
      final NotificationDetails notificationDetails = const NotificationDetails(
          android: AndroidNotificationDetails(
        "FFFAI",
        "FFFAI channel",

        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        // sound: RawResourceAndroidNotificationSound('beep'),
      ));

      await _notificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        // payload: body,
      );
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}
