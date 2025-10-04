import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import '../models/bus.dart';

Marker buildBusMarker(Bus bus, Color color, VoidCallback onTap) {
  const double markerSize = 20.0;
  return Marker(
    height: markerSize,
    width: markerSize + 5.0,
    alignment: Alignment.center,
    rotate: false,
    point: LatLng(bus.latitude, bus.longitude),
    child: GestureDetector(
      onTap: onTap,
      child: Transform.rotate(
        angle: (bus.dir - 90) * (math.pi / 180.0),
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: const Icon(
            Icons.airport_shuttle,
            color: Colors.black,
            size: markerSize,
            shadows: [
              Shadow(
                color: Colors.white54, // Outline color
                offset: Offset(0, 0),
                blurRadius: 1.0,
              ),
              // Add multiple shadows for thicker outline
              Shadow(
                color: Colors.white54,
                offset: Offset(1, 0),
                blurRadius: 1.0,
              ),
              Shadow(
                color: Colors.white54,
                offset: Offset(-1, 0),
                blurRadius: 1.0,
              ),
              Shadow(
                color: Colors.white54,
                offset: Offset(0, 1),
                blurRadius: 1.0,
              ),
              Shadow(
                color: Colors.white54,
                offset: Offset(0, -1),
                blurRadius: 1.0,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
