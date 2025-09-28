import 'package:bus_tracker/repositories/stop_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/stop.dart';

class MapProvider with ChangeNotifier {
  final StopRepository _stopRepository = StopRepository();
  List<Stop> _allStops = [];
  List<Stop> _visibleStops = [];
  List<Stop> get visibleStops => _visibleStops;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  MapProvider() {
    fetchAllStops();
  }

  Future<void> fetchAllStops() async {
    _isLoading = true;
    notifyListeners();
    _allStops = await _stopRepository.getAllStops();
    _isLoading = false;
    notifyListeners();
  }

  void updateVisibleStops(MapCamera camera){
    const minZoomForStops = 14.0;

    if(camera.zoom < minZoomForStops){
      _visibleStops = [];
    }else{
      _visibleStops = _allStops.where((stop) {
        return camera.visibleBounds.contains(LatLng(stop.latitude, stop.longitude));
      }).toList();
    }
    notifyListeners();
  }
}