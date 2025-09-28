import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import '../models/bus.dart';
import '../models/stop.dart';

Marker buildBusMarker(Bus bus, Color color, VoidCallback onTap) {
  return Marker(
    point: LatLng(bus.latitude, bus.longitude),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Transform.rotate(
          angle: (bus.dir - 90) * (math.pi / 180.0),
          // Assuming dir is in degrees,
          child: const Icon(
            Icons.airport_shuttle,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
    ),
  );
}
