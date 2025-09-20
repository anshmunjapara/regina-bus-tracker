import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'joke_service.dart';
import 'notifications.dart';

Timer? _jokeTimer;

Future<void> startLiveActivity() async {
  // Start immediately with one joke
  await _updateJokeNotification();

  // Then refresh every 10 seconds
  _jokeTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
    await _updateJokeNotification();
  });
}

Future<void> stopLiveActivity() async {
  _jokeTimer?.cancel();
  await flutterLocalNotificationsPlugin.cancel(0); // cancel notification
}

Future<void> _updateJokeNotification() async {
  final jokeType = await JokeService.fetchJokeType();

  const androidDetails = AndroidNotificationDetails(
    'live_joke_channel',
    'Live Joke Activity',
    channelDescription: 'Shows live jokes updating every 10 seconds',
    importance: Importance.max,
    priority: Priority.high,
    ongoing: true,
    showWhen: false,
  );

  const notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0, // ID
    'Live Joke Activity',
    jokeType ?? 'Error fetching joke',
    notificationDetails,
  );
}

Future<void> showTestNotification() async {
  const androidDetails = AndroidNotificationDetails(
    'test_channel',
    'Test Notifications',
    channelDescription: 'Simple test',
    importance: Importance.max,
    priority: Priority.high,
  );
  print("i got fired");
  const notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Hello',
    'This is a test notification',
    notificationDetails,
  );
}