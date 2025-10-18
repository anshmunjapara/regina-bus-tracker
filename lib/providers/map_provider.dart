import 'dart:async';

import 'package:bus_tracker/repositories/stop_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/stop.dart';

class MapProvider with ChangeNotifier {
  final StopRepository _stopRepository = StopRepository();
  List<Stop> _allStops = [];

  List<Stop> get allStops => _allStops;

  List<Stop> _visibleStops = [];

  List<Stop> get visibleStops => _visibleStops;

  Set<String> _selectedRoutes = <String>{};

  MapCamera? currentCamera;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  Timer? _debounce;

  MapProvider() {
    fetchAllStops();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> fetchAllStops() async {
    _isLoading = true;

    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _allStops = await _stopRepository.getAllStops();

    _isLoading = false;
    notifyListeners();
  }

  void onMapPositionChanged(MapCamera camera) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      currentCamera = camera;
      updateVisibleStops(_selectedRoutes);
    });
  }

  void updateVisibleStops(selectedRoutes) {
    _selectedRoutes = selectedRoutes;
    if (currentCamera != null) {
      const minZoomForStops = 15.0;
      if (currentCamera!.zoom < minZoomForStops) {
        _visibleStops = [];
      } else {
        _visibleStops = _allStops.where((stop) {
          return currentCamera!.visibleBounds
              .contains(LatLng(stop.latitude, stop.longitude));
        }).toList();

        _updateStopsBasedOnRoutes();
      }
    }
    notifyListeners();
  }

  void _updateStopsBasedOnRoutes() {
    if (_selectedRoutes.isNotEmpty) {
      _visibleStops = _visibleStops.where((stop) {
        return _selectedRoutes.isEmpty ||
            stop.routes.any((r) => _selectedRoutes.contains(r.toString()));
      }).toList();
    }
  }
}
