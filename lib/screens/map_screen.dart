import 'package:bus_tracker/providers/bus_provider.dart';
import 'package:bus_tracker/providers/map_provider.dart';
import 'package:bus_tracker/utils/bus_marker.dart';
import 'package:bus_tracker/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../utils/StopMarker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Regina Map")),
      body: Consumer<MapProvider>(builder: (context, mapProvider, child) {
        if (mapProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
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

              onMapReady: () =>
                  mapProvider.onMapPositionChanged(_mapController.camera),
              onPositionChanged: (camera, hasGesture) {
                if (hasGesture) {
                  mapProvider.onMapPositionChanged(camera);
                }
              },
            ),
            children: [
              // Base map tiles
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.bus_tracker',
              ),
              Consumer<MapProvider>(
                builder: (context, provider, child) {
                  return MarkerLayer(
                    markers: provider.visibleStops
                        .map((stop) => buildStopMarker(stop))
                        .toList(),
                  );
                },
              ),
              Consumer<BusProvider>(
                builder: (context, provider, child) {
                  return MarkerLayer(
                    markers: provider.buses.map((bus) {
                      final route = provider.routes[bus.route.toString()];
                      final color = route != null ? route.color.toColor() : Colors.grey;
                      return buildBusMarker(bus, color);
                    }).toList(),
                  );
                },
              ),
            ],
          );
        }
      }),
    );
  }
}