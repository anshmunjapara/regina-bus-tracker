import 'dart:async';

import 'package:bus_tracker/models/bus.dart';
import 'package:bus_tracker/repositories/bus_repository.dart';
import 'package:flutter/material.dart';

class BusProvider with ChangeNotifier {
  final BusRepository _busRepository = BusRepository();
  Timer? _busUpdateTimer;
  List<Bus> _buses = [];

  List<Bus> get buses => _buses;

  BusProvider() {
    fetchBuses();
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
}