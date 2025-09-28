import 'dart:async';

import 'package:bus_tracker/models/bus.dart';
import 'package:bus_tracker/models/route.dart';
import 'package:bus_tracker/repositories/bus_repository.dart';
import 'package:bus_tracker/repositories/route_repository.dart';
import 'package:flutter/material.dart';

class BusProvider with ChangeNotifier {
  final BusRepository _busRepository = BusRepository();
  final RouteRepository _routeRepository = RouteRepository();

  Timer? _busUpdateTimer;
  List<Bus> _buses = [];

  List<Bus> get buses => _buses;

  Map<String, RouteInfo> _routes = {};

  Map<String, RouteInfo> get routes => _routes;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  BusProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    // Fetch initial data
    await Future.delayed(const Duration(seconds: 1));
    await Future.wait([
      fetchRoutes(),
      fetchBuses(),
    ]);

    _isLoading = false;
    notifyListeners();

    // Start the timer for periodic updates
    _busUpdateTimer =
        Timer.periodic(const Duration(seconds: 7), (_) => fetchBuses());
  }

  @override
  void dispose() {
    _busUpdateTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchBuses() async {
    _buses = await _busRepository.getAllBuses();
    notifyListeners();
  }

  Future<void> fetchRoutes() async {
    _routes = await _routeRepository.getAllRoutes();
  }
}
