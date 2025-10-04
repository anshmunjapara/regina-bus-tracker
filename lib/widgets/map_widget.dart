import 'package:bus_tracker/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../models/bus.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../providers/bus_provider.dart';
import '../providers/map_provider.dart';
import '../utils/StopMarker.dart';
import '../utils/bus_marker.dart';

class MapWidget extends StatelessWidget {
  final Function(Bus) onBusTap;
  final MapController? mapController;

  const MapWidget({
    super.key,
    required this.onBusTap,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        return FlutterMap(
          mapController: mapController,
          options: _buildMapOptions(mapProvider),
          children: [
            _buildTileLayer(),
            _buildStopMarkers(),
            _buildBusMarkers(),
          ],
        );
      },
    );
  }

  MapOptions _buildMapOptions(MapProvider mapProvider) {
    return MapOptions(
      initialCenter: const LatLng(50.4452, -104.6189),
      // Regina center
      minZoom: 11.0,
      maxZoom: 17.0,
      cameraConstraint: CameraConstraint.contain(
        bounds: LatLngBounds(
          const LatLng(50.38, -104.75), // South-West
          const LatLng(50.52, -104.50), // North-East
        ),
      ),

      onMapReady: () => mapProvider.onMapPositionChanged(mapController!.camera),
      onPositionChanged: (camera, hasGesture) {
        if (hasGesture) {
          mapProvider.onMapPositionChanged(camera);
        }
      },
    );
  }

  Widget _buildTileLayer() {
    return TileLayer(
      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      userAgentPackageName: 'com.example.bus_tracker',
    );
  }

  Widget _buildStopMarkers() {
    return Consumer<MapProvider>(
      builder: (context, provider, child) {
        return MarkerLayer(
          markers: provider.visibleStops
              .map((stop) => buildStopMarker(stop))
              .toList(),
        );
      },
    );
  }

  Widget _buildBusMarkers() {
    return Consumer<BusProvider>(
      builder: (context, provider, child) {
        return MarkerLayer(
          markers: provider.buses.map((bus) {
            final route = provider.routes[bus.route.toString()];
            final color = route != null ? route.color.toColor() : Colors.grey;
            return buildBusMarker(bus, color, () => onBusTap(bus));
          }).toList(),
        );
      },
    );
  }
}
