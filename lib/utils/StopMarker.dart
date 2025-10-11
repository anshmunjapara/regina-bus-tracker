import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import '../models/stop.dart';

Marker buildStopMarker(Stop stop, VoidCallback onTap) {
  double rotation = 0.0;
  double offsetX = 0;
  double offsetY = 0;
  switch (stop.dir) {
    case 'NB':
      rotation = 0;
      offsetX = 15.0; // Shift right
      break;
    case 'SB':
      rotation = math.pi; // 180 degrees
      offsetX = -15.0; // Shift left
      break;
    case 'EB':
      rotation = math.pi / 2; // 90 degrees
      offsetY = 15.0; // Shift right
      break;
    case 'WB':
      rotation = -math.pi / 2; // -90 degrees
      offsetY = -15.0; // Shift left
      break;
  }
  return Marker(
    height: 22,
    width: 22,
    point: LatLng(stop.latitude, stop.longitude),
    child: Transform.translate(
      offset: Offset(offsetX, offsetY),
      child: Transform.rotate(
        angle: rotation,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent,
                border: Border.all(color: Colors.black, width: 1.5)),
            child: const Icon(
              Icons.arrow_upward,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    ),
  );
}
