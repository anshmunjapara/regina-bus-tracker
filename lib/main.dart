import 'package:bus_tracker/providers/bus_provider.dart';
import 'package:bus_tracker/providers/map_provider.dart';
import 'package:bus_tracker/providers/route_filter_provider.dart';
import 'package:bus_tracker/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/service_locator.dart';
import 'notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  setupLocator();
  await getIt.allReady();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MapProvider()),
        ChangeNotifierProvider(create: (context) => BusProvider()),
        ChangeNotifierProvider(create: (context) => RouteFilterProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Bus Tracker',
      home: MapScreen(),
    );
  }
}
