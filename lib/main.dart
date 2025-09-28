import 'package:bus_tracker/providers/bus_provider.dart';
import 'package:bus_tracker/providers/map_provider.dart';
import 'package:bus_tracker/repositories/bus_repository.dart';
import 'package:bus_tracker/repositories/stop_repository.dart';
import 'package:bus_tracker/screens/map_screen.dart';
import 'package:bus_tracker/services/api_service.dart';
import 'package:bus_tracker/utils/bus_activity_manager.dart';
import 'package:bus_tracker/widgets/BusDropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/bus.dart';
import 'models/stop.dart';
import 'notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MapProvider()),
        ChangeNotifierProvider(create: (context) => BusProvider()),
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

