import 'package:bus_tracker/screens/map_screen.dart';
import 'package:bus_tracker/services/api_service.dart';
import 'package:bus_tracker/utils/bus_activity_manager.dart';
import 'package:bus_tracker/widgets/BusDropdown.dart';
import 'package:flutter/material.dart';

import 'models/bus.dart';
import 'models/stop.dart';
import 'notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MapScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{

  List<Bus> _buses = [];
  List<Stop> _stops = [];
  Bus? _selectedBus;
  bool _isLoading = true;

  BusActivityManager? _manager;

  @override
  void initState() {
    super.initState();
    _loadStops();
    _loadBuses();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _manager?.stop(); // stop when widget is disposed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _manager?.stop(); // stop when app closes or backgrounded
    }
  }

  Future<void> _loadStops() async {
    try {
      final stops = await ApiService.fetchStops();
      setState(() {
        _stops = stops;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error loading stops: $e");
    }
  }

  Future<void> _loadBuses() async {
    try {
      final buses = await ApiService.fetchBuses();
      setState(() {
        _buses = buses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error loading buses: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedBus != null) {
                        // stop any previous tracking
                        _manager?.stop();

                        // start tracking for the selected bus
                        _manager = BusActivityManager(
                          selectedBus: _selectedBus!,
                          allStops: _stops,
                        );
                        _manager!.start();

                        print(
                            "Live activity started for bus ${_selectedBus!.route}");
                      } else {
                        print("No bus selected");
                        showErrorNotification("Please select a bus first");
                      }
                    },
                    child: const Text("Start Live Activity"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _manager?.stop();
                      print("Live activity stopped");
                    },
                    child: const Text("Stop Live Activity"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: BusDropdown(
                      buses: _buses,
                      selectedBus: _selectedBus,
                      onChanged: (bus) {
                        setState(() {
                          _selectedBus = bus;
                        });
                        print("Selected bus: ${bus?.route} - ${bus?.line}");
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_selectedBus != null)
                    Text("You selected Bus ${_selectedBus!.route}"),
                ],
              ),
      ),
    );
  }
}
