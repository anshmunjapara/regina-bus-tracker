import '../models/bus.dart';
import '../models/stop.dart';

/// Utility class for calculating distances and finding closest stops
class DistanceCalculator {
  // Constants for Regina, Saskatchewan (latitude ~50.4°)
  static const double _latDegreeToMeters = 111000.0;
  static const double _lngDegreeToMeters = 71000.0; // cos(50.4°) * 111000

  /// Finds the closest bus stop to the given bus using optimized filtering
  ///
  /// [bus] - Current bus object with coordinates
  /// [allStops] - List of all bus stops to search through
  /// [radiusMeters] - Search radius in meters (default: 600m)
  ///
  /// Returns the closest Stop or null if no stops found within radius
  static Stop? findClosestStop(
    Bus bus,
    List<Stop> allStops, {
    double radiusMeters = 600.0,
  }) {
    if (allStops.isEmpty) return null;

    final candidateStops = _applyBoundingBoxFilter(
      bus,
      allStops,
      radiusMeters,
    );

    if (candidateStops.isEmpty) return null;

    return _findClosestUsingManhattan(bus, candidateStops);
  }

  /// Filters stops using bounding box to eliminate distant stops quickly
  static List<Stop> _applyBoundingBoxFilter(
    Bus bus,
    List<Stop> allStops,
    double radiusMeters,
  ) {
    // Convert radius from meters to degrees
    final latDelta = radiusMeters / _latDegreeToMeters;
    final lngDelta = radiusMeters / _lngDegreeToMeters;

    // Define bounding box
    final minLat = bus.latitude - latDelta;
    final maxLat = bus.latitude + latDelta;
    final minLng = bus.longitude - lngDelta;
    final maxLng = bus.longitude + lngDelta;

    // Filter stops within bounding box
    return allStops.where((stop) {
      return stop.latitude >= minLat &&
          stop.latitude <= maxLat &&
          stop.longitude >= minLng &&
          stop.longitude <= maxLng;
    }).toList();
  }

  /// Finds the closest stop using Manhattan distance calculation
  static Stop _findClosestUsingManhattan(
    Bus bus,
    List<Stop> candidateStops,
  ) {
    Stop closestStop = candidateStops.first;
    double minDistance = double.infinity;

    for (final stop in candidateStops) {
      final distance = _calculateManhattanDistance(
        bus.latitude,
        bus.longitude,
        stop.latitude,
        stop.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        closestStop = stop;
      }
    }

    return closestStop;
  }

  /// Calculates Manhattan distance between two coordinate pairs (in degrees)
  static double _calculateManhattanDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    final latDiff = (lat1 - lat2).abs();
    final lngDiff = (lng1 - lng2).abs();
    return latDiff + lngDiff;
  }
}
