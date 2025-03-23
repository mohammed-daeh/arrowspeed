// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

/////
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("e788098d-4d6b-4cb1-9b63-722dc43921f1");
//////
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String? loginEmail = prefs.getString('loginEmail'); // 👈 جديد
  String initialRoute;

  if (isLoggedIn) {
    if (loginEmail != null && loginEmail.endsWith('@admin.com')) {
      initialRoute = AppRouter.adminHome;
    } else if (loginEmail != null && loginEmail.endsWith('@driver.com')) {
      initialRoute = AppRouter.adminHome;
    } else {
      initialRoute = AppRouter.mainHome;
    }
  } else {
    initialRoute = AppRouter.splash;
  }

////
  await Firebase.initializeApp();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
////
  await AwesomeNotifications().removeChannel('basic_channel');

  await Utils.loadTranslations('assets/translations.json');
////
  await AwesomeNotifications().initialize(
    'resource://mipmap/ic_launcher',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Channel for basic notifications',
        enableVibration: true,
        ledColor: Colors.red,
        ledOnMs: 1000,
        ledOffMs: 500,
        importance: NotificationImportance.Max,
        playSound: true,
        defaultRingtoneType: DefaultRingtoneType.Notification,
        soundSource: 'resource://raw/notification_sound',
      ),
    ],
  );
////
  runApp(MyApp(
    initialRoute: initialRoute,
  ));
}

class DefaultFirebaseOptions {}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    var currentLocale = Utils.getLanguage();
    var textDirection = Utils.getTextDirection();
///////
    return GetMaterialApp(
        supportedLocales: [
          Locale('ar', ''),
          Locale('en', ''),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale(currentLocale),
        fallbackLocale: Locale('en'),
        textDirection: textDirection,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.greyback,
          brightness: Brightness.light,
          textTheme: TextTheme(
            bodyMedium: TextStyle(fontFamily: 'Zain'),
          ),
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        getPages: AppRouter.appPages);
  }
}
