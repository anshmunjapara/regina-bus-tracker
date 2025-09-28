import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import '../models/bus.dart';
import '../models/stop.dart';

Marker buildBusMarker(Bus bus, Color color) {
  return Marker(
    point: LatLng(bus.latitude, bus.longitude),
    child: Transform.rotate(
      angle: (bus.dir-90) * (math.pi / 180.0), // Assuming dir is in degrees,
      child: Icon(
        Icons.airport_shuttle,
        color: color,
        size: 30,
      ),
    ),
  );
}
