import '../models/bus.dart';
import '../models/stop.dart';
import '../providers/bus_provider.dart';
import '../utils/bus_activity_manager.dart';

class BusTrackingService {
  BusActivityManager? _activityManager;

  void startTracking(Bus bus, List<Stop> allStops, BusProvider busProvider) {
    stopTracking();
    _activityManager = BusActivityManager(
      selectedBus: bus,
      allStops: allStops,
      busProvider: busProvider,
    );
    _activityManager!.start();
  }

  void stopTracking() {
    _activityManager?.stop();
    _activityManager = null;
  }

  bool get isTracking => _activityManager != null;
}
