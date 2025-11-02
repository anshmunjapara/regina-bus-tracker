import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

double getBearing(LatLng from, LatLng to) {
  final lat1 = degreesToRadians(from.latitude);
  final lat2 = degreesToRadians(to.latitude);
  final dLon = degreesToRadians(to.longitude - from.longitude);

  final y = math.sin(dLon) * math.cos(lat2);
  final x = math.cos(lat1) * math.sin(lat2) -
      math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

  final brng = math.atan2(y, x);
  return (radiansToDegrees(brng) + 360) % 360; // Normalize 0–360
}

double degreesToRadians(double deg) => deg * math.pi / 180;

double radiansToDegrees(double rad) => rad * 180 / math.pi;
