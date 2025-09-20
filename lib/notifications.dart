import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

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

    // Test notification channel
    const AndroidNotificationChannel testChannel = AndroidNotificationChannel(
      'test_channel',
      'Test Notifications',
      description: 'Simple test notifications',
      importance: Importance.max,
    );

    // Live activity channel
    const AndroidNotificationChannel liveChannel = AndroidNotificationChannel(
      'live_joke_channel',
      'Live Joke Activity',
      description: 'Shows live jokes updating every 10 seconds',
      importance: Importance.max,
    );

    await androidImplementation?.createNotificationChannel(testChannel);
    await androidImplementation?.createNotificationChannel(liveChannel);
  }
}
