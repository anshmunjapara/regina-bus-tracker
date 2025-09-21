import 'package:bus_tracker/services/api_service.dart';
import 'package:bus_tracker/widgets/BusDropdown.dart';
import 'package:flutter/material.dart';

import 'handle_notification.dart';
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Bus> _buses = [];
  List<Stop> _stops = [];
  Bus? _selectedBus;
  bool _isLoading = true;
  ApiService myApi = ApiService();

  @override
  void initState() {
    super.initState();
    _loadStops();
    _loadBuses();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  Future<void> _loadStops() async {
    try {
      final stops = await myApi.fetchStops();
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
      final buses = await myApi.fetchBuses();
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
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      startLiveActivity();
                    },
                    child: const Text("Start Live Activity"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      stopLiveActivity();
                    },
                    child: const Text("Stop Live Activity"),
                  ),
                  const ElevatedButton(
                    onPressed: showTestNotification,
                    child: Text("Show Test Notification"),
                  ),
                  BusDropdown(
                    buses: _buses,
                    selectedBus: _selectedBus,
                    onChanged: (bus) {
                      setState(() {
                        _selectedBus = bus;
                      });
                      print("Selected bus: ${bus?.route} - ${bus?.line}");
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_selectedBus != null)
                    Text("You selected Bus ${_selectedBus!.route}"),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
