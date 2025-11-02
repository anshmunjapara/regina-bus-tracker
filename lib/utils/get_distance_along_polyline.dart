import 'package:latlong2/latlong.dart';

import 'get_bearing.dart';

double getDistanceAlongPolyline(
  LatLng point,
  List<LatLng> polyline,
  double dir, {
  double toleranceDegrees = 30,
}) {
  const distance = Distance(); // from latlong2
  double minDistToLine = double.infinity;
  LatLng? bestProjectionPoint;
  int bestSegmentIndex = -1;
  double distAlongToBestSegmentStart = 0.0;
  double cumulativeDistance = 0.0;

  for (int i = 0; i < polyline.length - 1; i++) {
    final a = polyline[i];
    final b = polyline[i + 1];

    // Compute the segment bearing (0–360)
    final segmentBearing = getBearing(a, b);

    // Compare with desired direction
    final diff = angleDifference(segmentBearing, dir);

    if (diff <= toleranceDegrees) {
      // Perform projection math
      final px = point.longitude;
      final py = point.latitude;
      final ax = a.longitude;
      final ay = a.latitude;
      final bx = b.longitude;
      final by = b.latitude;

      final dx = bx - ax;
      final dy = by - ay;

      if (!(dx == 0 && dy == 0)) {
        final dotProduct = ((px - ax) * dx + (py - ay) * dy);
        final squaredLength = dx * dx + dy * dy;
        final t = (dotProduct / squaredLength).clamp(0.0, 1.0);

        final projLon = ax + t * dx;
        final projLat = ay + t * dy;
        final projection = LatLng(projLat, projLon);

        final distToProjection =
            distance.distance(point, projection) / 1000.0; // km

        if (distToProjection < minDistToLine) {
          minDistToLine = distToProjection;
          bestProjectionPoint = projection;
          bestSegmentIndex = i;
          distAlongToBestSegmentStart = cumulativeDistance;
        }
      }
    }

    // Always accumulate total polyline distance
    cumulativeDistance += distance.distance(a, b) / 1000.0;
  }

  if (bestSegmentIndex == -1 || bestProjectionPoint == null) {
    return -1.0; // no matching segment
  }

  final distFromSegmentStart =
      distance.distance(polyline[bestSegmentIndex], bestProjectionPoint) /
          1000.0;

  return distAlongToBestSegmentStart + distFromSegmentStart;
}

double angleDifference(double a, double b) {
  double diff = (a - b).abs() % 360;
  return diff > 180 ? 360 - diff : diff;
}
