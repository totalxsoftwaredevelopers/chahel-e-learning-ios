import 'dart:async';

import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/controller/banner_controller.dart';
import 'package:chahele_project/controller/course_provider.dart';
import 'package:chahele_project/controller/image_provider.dart';
import 'package:chahele_project/controller/notification_provider.dart';
import 'package:chahele_project/controller/payment_gateway_controller.dart';
import 'package:chahele_project/controller/plan_controller.dart';
import 'package:chahele_project/controller/user_provider.dart';
import 'package:chahele_project/firebase_options.dart';
import 'package:chahele_project/view/splash_screen/on_board_screen_animation.dart';
import 'package:chahele_project/view/splash_screen/spalsh_screen.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'Channel_id', 'channel_name',
    importance: Importance.high, playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification androidNotification = message.notification!.android!;
      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    color: Colors.blue,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification androidNotification = message.notification!.android!;
      // if(notification!= null && androidNotification != null){

      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (context) => CourseProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ImagePickProvider()),
        ChangeNotifierProvider(create: (context) => BannerController()),
        ChangeNotifierProvider(create: (context) => PlanController()),
        ChangeNotifierProvider(create: (context) => PaymentGatewayProvider()),
        ChangeNotifierProvider(create: (context) => NotificationController()),
      ],
      child: MaterialApp(
        supportedLocales: const [
          Locale('en', 'US'),
        ],
        localizationsDelegates: const [
          CountryLocalizations.delegate,
        ],
        // ignore: deprecated_member_use
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
        debugShowCheckedModeBanner: false,

        home: FutureBuilder<bool>(
          future: installedFirtTime(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return OnBoardScreen();
            } else {
              return SplashScreen();
            }
          },
        ),
      ),
    );
  }

  Future<bool> installedFirtTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    bool isFirstTime = preferences.getBool('firstTime') ?? true;

    if (isFirstTime == true) {
      await preferences.setBool('firstTime', false);
    }
    return isFirstTime;
  }
}
