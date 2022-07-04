import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../Providers/UpdateIndexProvider.dart';

class LocalNotificationFlutter {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //initialize android notification channel
  static final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'pushnotificationCustomerapp', // id
    'pushnotificationCustomerapp channel', // title// description
    importance: Importance.max,
  );

  static void initialize(BuildContext context) async {
    final initializeAndroidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final initializeSettingIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    //local notification channel for ios
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    var initializedSettings = InitializationSettings(
        android: initializeAndroidSettings, iOS: initializeSettingIOS);
    await flutterLocalNotificationsPlugin.initialize(initializedSettings,
        onSelectNotification: (String? payload) async {
          if (payload == "order" || payload == "booking") {
            //HiveServices.removeAll();
            Provider.of<UpdateIndexProvider>(context,listen: false).setIndex(2);
            //Navigator.of(context).pushNamed(TabsScreen.routeName);
          }
        });
  }

  static void display(RemoteMessage message) {
    try {
      flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification?.title,
          message.notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.max,
                priority: Priority.high),
            iOS: IOSNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: message.data["route"]);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  static void onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    print(body);
  }
}