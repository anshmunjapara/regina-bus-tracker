import 'dart:async';
import 'dart:math' as math;

import 'package:bus_tracker/providers/map_provider.dart';
import 'package:bus_tracker/repositories/bus_repository.dart';
import 'package:bus_tracker/repositories/stop_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/bus.dart';
import '../models/stop.dart';
import '../services/api_service.dart';
import '../utils/StopMarker.dart';
import '../utils/bus_activity_manager.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  final MapController _mapController = MapController();

  // Timer? _debounce;
  // List<Bus> _buses = [];
  // List<Stop> _stops = [];
  // Bus? _selectedBus;
  // List<Stop> _visibleStops = [];
  // bool _isLoading = true;
  //
  // BusActivityManager? _manager;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadStops();
  //   _loadBuses();
  //   WidgetsBinding.instance.addObserver(this);
  // }

  // @override
  // void dispose() {
  //   _debounce?.cancel();
  //   WidgetsBinding.instance.removeObserver(this);
  //   _manager?.stop(); // stop when widget is disposed
  //   super.dispose();
  // }
  //
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.detached) {
  //     _manager?.stop(); // stop when app closes or backgrounded
  //   }
  // }
  //
  // Future<void> _loadStops() async {
  //   try {
  //     final stops = await _stopRepository.getAllStops();
  //     setState(() {
  //       _stops = stops;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     print("Error loading stops: $e");
  //   }
  // }
  //
  // Future<void> _loadBuses() async {
  //   try {
  //     final buses = await _busRepository.getAllBuses();
  //     setState(() {
  //       _buses = buses;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     print("Error loading buses: $e");
  //   }
  // }

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
            ],
          );
        }
      }),
    );
  }
}
