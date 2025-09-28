import 'dart:async';
import 'package:bus_tracker/services/api_service.dart';

import '../models/bus.dart';
import '../models/stop.dart';
import '../notifications.dart';
import '../repositories/bus_repository.dart';
import '../utils/distance_calculator.dart';

class BusActivityManager {
  final BusRepository _busRepository = BusRepository();
  Timer? _timer;
  final Bus selectedBus;
  final List<Stop> allStops;
  DateTime? _startTime;

  BusActivityManager({required this.selectedBus, required this.allStops});

  void start() {
    _startTime = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      //Auto-stop after 15 minutes
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
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}