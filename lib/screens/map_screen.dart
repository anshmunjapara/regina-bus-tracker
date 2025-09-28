import 'dart:async';
import 'dart:math' as math;

import 'package:bus_tracker/repositories/bus_repository.dart';
import 'package:bus_tracker/repositories/stop_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/bus.dart';
import '../models/stop.dart';
import '../services/api_service.dart';
import '../utils/bus_activity_manager.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  final MapController _mapController = MapController();
  final BusRepository _busRepository = BusRepository();
  final StopRepository _stopRepository = StopRepository();
  Timer? _debounce;
  List<Bus> _buses = [];
  List<Stop> _stops = [];
  Bus? _selectedBus;
  List<Stop> _visibleStops = [];
  bool _isLoading = true;

  BusActivityManager? _manager;

  @override
  void initState() {
    super.initState();
    _loadStops();
    _loadBuses();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _manager?.stop(); // stop when widget is disposed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _manager?.stop(); // stop when app closes or backgrounded
    }
  }

  Future<void> _loadStops() async {
    try {
      final stops = await _stopRepository.getAllStops();
      setState(() {
        _stops = stops;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error loading stops: $e");
    }
  }

  Future<void> _loadBuses() async {
    try {
      final buses = await _busRepository.getAllBuses();
      setState(() {
        _buses = buses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error loading buses: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Regina Map")),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: const LatLng(50.4452, -104.6189), // Regina center
          minZoom: 11.0,
          maxZoom: 17.0,
          cameraConstraint: CameraConstraint.contain(
            bounds: LatLngBounds(
              const LatLng(50.38, -104.75), // South-West
              const LatLng(50.52, -104.50), // North-East
            ),
          ),
          onMapReady: () {
            _updateVisibleStops();
          },
          onPositionChanged: (MapCamera position, bool hasGesture) {
            if (_debounce?.isActive ?? false) _debounce!.cancel();
            _debounce = Timer(const Duration(milliseconds: 400), () {
              _updateVisibleStops();
            });
          },
        ),
        children: [
          // Base map tiles
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.bus_tracker',
          ),

          // Stop markers
          MarkerLayer(
            markers: [
              ..._visibleStops.map((stop) => _buildStopMarker(stop)),
            ],
          ),
        ],
      ),
    );
  }

  void _updateVisibleStops() {
    const minZoomForStops = 15.0;

    if (_mapController.camera.zoom < minZoomForStops) {
      setState(() {
        _visibleStops = [];
      });

      return;
    }

    if (_mapController.camera.visibleBounds == null) return;
    final bounds = _mapController.camera.visibleBounds;
    final visibleStops = _stops.where((stop) {
      return bounds.contains(LatLng(stop.latitude, stop.longitude));
    }).toList();

    setState(() {
      _visibleStops = visibleStops;
    });
  }

  Marker _buildStopMarker(Stop stop) {
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
      point: LatLng(stop.latitude, stop.longitude),
      child: Transform.translate(
        offset: Offset(offsetX, offsetY),
        child: Transform.rotate(
          angle: rotation,
          child: Container(
            color: Colors.black87,
            child: const Icon(
              Icons.arrow_upward,
              color: Colors.blue,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
