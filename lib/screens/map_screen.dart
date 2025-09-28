import 'package:bus_tracker/providers/bus_provider.dart';
import 'package:bus_tracker/providers/map_provider.dart';
import 'package:bus_tracker/utils/bus_marker.dart';
import 'package:bus_tracker/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/bus.dart';
import '../utils/StopMarker.dart';
import '../utils/bus_activity_manager.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  final MapController _mapController = MapController();
  BusActivityManager? _activityManager;

  @override
  void dispose() {
    _activityManager?.stop();
    super.dispose();
  }

  void _handleBusTap(Bus bus) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Track Bus ${bus.route}'),
            content: const Text(
                'Receive notifications for this bus? This will stop after 20 minutes.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                child: const Text('Track'),
                onPressed: () {
                  _activityManager?.stop();
                  _activityManager = null;

                  final busProvider =
                      Provider.of<BusProvider>(context, listen: false);

                  final allStops =
                      Provider.of<MapProvider>(context, listen: false).allStops;

                  // Create and start the manager
                  _activityManager = BusActivityManager(
                    selectedBus: bus,
                    allStops: allStops,
                    busProvider: busProvider,
                  );
                  _activityManager!.start();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Regina Map"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_off),
            onPressed: () {
              _activityManager?.stop();
              _activityManager = null;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bus tracking stopped.')),
              );
            },
          )
        ],
      ),
      body: Consumer2<MapProvider, BusProvider>(
          builder: (context, mapProvider, busProvider, child) {
        if (mapProvider.isLoading || busProvider.isLoading) {
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
                      final color =
                          route != null ? route.color.toColor() : Colors.grey;
                      return buildBusMarker(
                          bus, color, () => _handleBusTap(bus));
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
