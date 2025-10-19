import 'package:flutter/foundation.dart';
import '../models/bus.dart';
import '../models/stop.dart';
import '../providers/bus_provider.dart';
import '../utils/bus_activity_manager.dart';

class BusTrackingService {
  BusActivityManager? _activityManager;

  final ValueNotifier<bool> isTracking = ValueNotifier(false);

  void startTracking(Bus bus, List<Stop> allStops, BusProvider busProvider) {
    stopTracking();
    _activityManager = BusActivityManager(
      selectedBus: bus,
      allStops: allStops,
      busProvider: busProvider,
    );
    _activityManager!.start();
    isTracking.value = true;
  }

  void stopTracking() {
    _activityManager?.stop();
    _activityManager = null;
    isTracking.value = false;
  }
}
