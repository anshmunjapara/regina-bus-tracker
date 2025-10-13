import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

import 'models/bus.dart';
import 'models/stop.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Request permissions for Android 13+
  if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // Create notification channels for Android
  await _createNotificationChannels();
}

Future<void> _createNotificationChannels() async {
  if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    // Live activity channel
    const AndroidNotificationChannel liveChannel = AndroidNotificationChannel(
      'live_bus_activity',
      'Live Bus Activity',
      description: 'Shows live location of bus updating every 7 seconds',
      importance: Importance.max,
      playSound: false,
    );

    await androidImplementation?.createNotificationChannel(liveChannel);
  }
}

Future<void> showBusNotification(Bus bus, Stop? stop) async {
  var androidDetails = const AndroidNotificationDetails(
    'live_bus_activity',
    'Live Bus Activity',
    channelDescription: 'Shows live location of selected bus',
    importance: Importance.max,
    priority: Priority.high,
    ongoing: true,
    showWhen: false,
    playSound: false,
    color: Colors.yellowAccent,
    colorized: true,
    // largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
  );

  var notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Bus ${bus.route} - ${bus.line}',
    stop != null ? 'Next Stop: ${stop.name}' : 'No nearby stop found',
    notificationDetails,
  );
}

Future<void> showErrorNotification(String message) async {
  const androidDetails = AndroidNotificationDetails(
    'live_bus_activity',
    'Live Bus Activity',
    channelDescription: 'Shows live location of selected bus',
    importance: Importance.max,
    priority: Priority.high,
    ongoing: false,
  );

  const notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    1, // different ID from bus tracking
    'Error',
    message,
    notificationDetails,
  );
}
