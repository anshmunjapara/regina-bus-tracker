import 'dart:async';

import 'package:bus_tracker/utils/get_distance_along_polyline.dart';
import 'package:latlong2/latlong.dart';
import 'package:turf/along.dart';
import 'package:turf/nearest_point_on_line.dart';

import '../models/bus.dart';
import '../models/processed_route_stop.dart';
import '../models/stop.dart';
import '../notifications.dart';
import '../providers/bus_provider.dart';
import '../repositories/bus_repository.dart';

class BusActivityManager {
  final Bus selectedBus;
  final List<Stop> allStops;
  final BusProvider busProvider;
  final BusRepository _busRepository = BusRepository();
  ProcessedStop? oldStop;
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
      final ProcessedStop? nextProcessedStop = _findNextBusStop(bus);

      if (nextProcessedStop != null) {
        if (oldStop?.id != nextProcessedStop.id) {
          oldStop = nextProcessedStop;
          await showBusNotification(bus, nextProcessedStop.name);
        }
      } else {
        await showErrorNotification("Stop not found");
        stop();
      }
    } else {
      await showErrorNotification("Bus not found");
      stop();
    }
  }

  ProcessedStop? _findNextBusStop(Bus currentBus) {
    final processedRouteStops =
        busProvider.allProcessedStops[currentBus.route.toString()];
    if (processedRouteStops == null || processedRouteStops.isEmpty) {
      return null;
    }

    final routeInfo = busProvider.routes[currentBus.route.toString()];
    if (routeInfo == null) return null;

    final LatLng busPosition =
        LatLng(currentBus.latitude, currentBus.longitude);

    final busDistanceAlongRoute = getDistanceAlongPolyline(
        busPosition, routeInfo.points, currentBus.dir.toDouble());

    for (final stop in processedRouteStops) {
      if (stop.distanceAlongRoute > busDistanceAlongRoute) {
        return stop;
      }
    }
    if (processedRouteStops.isNotEmpty) {
      return processedRouteStops.first;
    }
    return null;
  }

  void start() {
    _startTime = DateTime.now();
    busProvider.addListener(_onBusDataUpdated);
    busProvider
        .startTracking(); //to tell provider that user is tracking for the background updates
    _onBusDataUpdated();
  }

  void stop() {
    busProvider.removeListener(_onBusDataUpdated);
    busProvider
        .stopTracking(); // to tell provider that user is not tracking for the background updates
  }
}
