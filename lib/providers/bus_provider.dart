import 'dart:async';

import 'package:bus_tracker/models/bus.dart';
import 'package:bus_tracker/models/route.dart';
import 'package:bus_tracker/repositories/bus_repository.dart';
import 'package:bus_tracker/repositories/route_repository.dart';
import 'package:flutter/material.dart';
import 'package:turf/along.dart';

import '../models/processed_route_stop.dart';
import '../models/stop.dart';
import '../utils/route_processing.dart';

class BusProvider extends ChangeNotifier with WidgetsBindingObserver {
  final BusRepository _busRepository = BusRepository();
  final RouteRepository _routeRepository = RouteRepository();

  Timer? _busUpdateTimer;
  bool _isAppInBackground = false;
  bool _isUserTracking = false;

  List<Bus> _buses = [];

  List<Bus> get buses => _buses;

  Map<String, RouteInfo> _routes = {};

  Map<String, RouteInfo> get routes => _routes;

  bool _isLoading = true;

  bool get isLoading => _isLoading;
  bool isProcessingComplete = false;

  Map<String, List<ProcessedRouteStop>> processedRoutes = {};

  BusProvider() {
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  Future<void> _initialize() async {
    // Fetch initial data
    await Future.delayed(const Duration(seconds: 1));
    await Future.wait([
      fetchRoutes(),
    ]);

    _isLoading = false;
    notifyListeners();

    // Start the timer for periodic updates
    _createUpdateTimer();
  }

  @override
  void dispose() {
    _busUpdateTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isAppInBackground = (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden);
    _updateTimerBasedOnState();
  }

  Future<void> fetchBuses() async {
    _buses = await _busRepository.getAllBuses();
    notifyListeners();
  }

  Future<void> fetchRoutes() async {
    _routes = await _routeRepository.getAllRoutes();
  }

  Future<void> processAllRoutes(List<Stop> allStops) async {
    if (isProcessingComplete) return;

    for (var route in _routes.values) {
      final routePolyline = LineString(
        coordinates:
            route.points.map((p) => Position(p.longitude, p.latitude)).toList(),
      );

      final processedStops = await preprocessRouteStops(
        routeId: route.routeNumber,
        allStopsInCity: allStops,
        routePolyline: routePolyline,
      );
      processedRoutes[route.routeNumber] = processedStops;
    }

    isProcessingComplete = true;
    notifyListeners();
  }

  void _updateTimerBasedOnState() {
    final shouldUpdate = _shouldUpdateBuses();

    if (shouldUpdate && _busUpdateTimer == null) {
      _createUpdateTimer();
    } else if (!shouldUpdate) {
      _cancelUpdateTimer();
    }
  }

  bool _shouldUpdateBuses() {
    // Update logic decision tree:
    // 1. If app is in foreground → Always update
    // 2. If app is in background AND user is tracking → Update
    // 3. If app is in background AND user is NOT tracking → Don't update

    if (!_isAppInBackground) return true; // Foreground: always update
    return _isUserTracking; // Background: only if tracking
  }

  void _createUpdateTimer() {
    _busUpdateTimer = Timer.periodic(
      const Duration(seconds: 7),
      (_) => fetchBuses(),
    );
    fetchBuses(); // Immediate fetch
    // print(
    //     "✅ Bus updates ENABLED - Background: $_isAppInBackground, Tracking: $_isUserTracking");
  }

  void _cancelUpdateTimer() {
    _busUpdateTimer?.cancel();
    _busUpdateTimer = null;
    // print(
    //     "❌ Bus updates DISABLED - Background: $_isAppInBackground, Tracking: $_isUserTracking");
  }

  void startTracking() {
    _isUserTracking = true;
    _updateTimerBasedOnState();
  }

  void stopTracking() {
    _isUserTracking = false;
    _updateTimerBasedOnState();
  }
}
