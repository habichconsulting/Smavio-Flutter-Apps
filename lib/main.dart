import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smavio/firebase_options.dart';
import 'package:smavio/screens/splash_scrn.dart';
import 'package:smavio/services/services.dart';
import 'package:smavio/utils/local_storage_modal.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'Smavio', // id
  'Smavio channel', // title
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  LocalNotificationService.initialize();
  log(message.toString());

  // await Firebase.initializeApp();
  String a = message.data['title'].toString();
  String b = message.data['body'].toString();
  log('$a,$b');
  LocalNotificationService.display(title: a, body: b);
  // SharedPreferences prf = await SharedPreferences.getInstance();
  // bool? isNotify = prf.getBool('isNotify');
  // log('notification toggle $isNotify');
}

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isMacOS) {
    

  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  await Hive.initFlutter();
  Hive.registerAdapter(LoginDataAdapter());
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  Platform.isWindows || Platform.isMacOS
      ? null
      : FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? fcm;
  notificationMethod() {
    LocalNotificationService.initialize();

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      // log(message!.data.toString());
      // if (message != null) {
      //   Navigator.pushNamed(context, NotificatonScrn.routeName);
      // }
    });

    // ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {}
      String a = message.data['title'].toString();
      String b = message.data['body'].toString();
      log('$a,$b');
      LocalNotificationService.display(
          body: message.notification!.body!,
          title: message.notification!.title!);
      log(" onMessage Triggerd${message.toString()}");
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        log('tapped on notification banner');
      }
    });
  }

  // //generate fcm token
  generatfcmtoken() async {
    await FirebaseMessaging.instance.getToken().then((value) async {
      fcm = value;
      log("fcm Token $fcm");
    });
  }

  @override
  void initState() {
    if (Platform.isWindows || Platform.isMacOS) {
    } else {
      notificationMethod();
      generatfcmtoken();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'smavio',
      theme: ThemeData(),
      // theme: ThemeData(
      //     textTheme: TextTheme(
      //       headline1: TextStyle(color: Colors.black),
      //       subtitle1: TextStyle(color: Colors.white))),
      // home:  const AppWebView(url: 'https://sandbox.smavio.de/campaign/1/preview?deviceid=0097ef7e-efab-4546-9f5c-2a4e756b3f34', appname: '', deviceId: '0097ef7e-efab-4546-9f5c-2a4e756b3f34',),
      home: const SplashScrn(),
      // home:  AppWebView(),
      navigatorKey: navigatorKey,
    );
  }
}
