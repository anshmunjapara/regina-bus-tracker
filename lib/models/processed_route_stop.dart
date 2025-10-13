import 'package:bus_tracker/models/stop.dart';

class ProcessedRouteStop {
  final Stop originalStop;
  final double distanceAlongRoute;

  ProcessedRouteStop({
    required this.originalStop,
    required this.distanceAlongRoute,
  });
}
