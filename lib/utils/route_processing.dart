import 'package:turf/along.dart';
import 'package:turf/nearest_point_on_line.dart';

import '../models/processed_route_stop.dart';
import '../models/stop.dart';

Future<List<ProcessedRouteStop>> preprocessRouteStops(
    {required String routeId,
    required List<Stop> allStopsInCity,
    required LineString routePolyline}) async {
  final stopsForThisRoute = allStopsInCity
      .where((stop) => stop.routes.contains(int.parse(routeId)))
      .toList();
  List<ProcessedRouteStop> processedStops = [];

  for (final stop in stopsForThisRoute) {
    final stopPosition = Position(stop.longitude, stop.latitude);
    final projectedPointFeature =
        nearestPointOnLine(routePolyline, Point(coordinates: stopPosition));
    final distance =
        (projectedPointFeature.properties?['location'] as num).toDouble();
    processedStops.add(ProcessedRouteStop(
      originalStop: stop,
      distanceAlongRoute: distance,
    ));
  }

  processedStops
      .sort((a, b) => a.distanceAlongRoute.compareTo(b.distanceAlongRoute));
  return processedStops;
}
