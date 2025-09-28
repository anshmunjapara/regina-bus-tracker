import 'dart:async';
import 'package:bus_tracker/services/api_service.dart';

import '../models/bus.dart';
import '../models/stop.dart';
import '../notifications.dart';
import '../providers/bus_provider.dart';
import '../repositories/bus_repository.dart';
import '../utils/distance_calculator.dart';

class BusActivityManager {
  final Bus selectedBus;
  final List<Stop> allStops;
  final BusProvider busProvider;
  final BusRepository _busRepository = BusRepository();
  DateTime? _startTime;

  BusActivityManager(
      {required this.selectedBus,
      required this.allStops,
      required this.busProvider});

  Future<void> _onBusDataUpdated() async {
    if (_startTime != null &&
        DateTime.now().difference(_startTime!).inMinutes >= 2) {
      stop();
      await showErrorNotification("Tracking stopped after 15 minutes");
      return;
    }

    final bus = await _busRepository.getBusByID(selectedBus);

    if (bus != null) {
      final stop = DistanceCalculator.findClosestStop(bus, allStops);

      await showBusNotification(bus, stop);
    } else {
      await showErrorNotification("Bus not found");
      stop();
    }
  }

  void start() {
    _startTime = DateTime.now();
    busProvider.addListener(_onBusDataUpdated);
    _onBusDataUpdated();
  }

  void stop() {
    busProvider.removeListener(_onBusDataUpdated);
  }
}
