import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bus_timings.dart';
import '../repositories/bus_timing_repository.dart';
import '../providers/route_filter_provider.dart';
import '../models/stop.dart';

class BusTimingProvider with ChangeNotifier {
  List<BusTiming> _busTimings = [];
  bool _isLoading = false;

  List<BusTiming> get busTimings => _busTimings;

  bool get isLoading => _isLoading;

  Stop? _currentStop;

  Stop? get currentStop => _currentStop;

  /// Call this when a user selects a stop.
  Future<void> loadBusTimings(BuildContext context, Stop stop) async {
    _currentStop = stop;
    _isLoading = true;
    notifyListeners();

    final routeFilterProvider = context.read<RouteFilterProvider>();
    _busTimings = await getBusTimings(
      stop.stopId,
      routeFilterProvider.selectedRoutes,
    );

    _isLoading = false;
    notifyListeners();
  }

// /// Called when route filters change.
// Future<void> refreshTimings(BuildContext context) async {
//   if (_currentStop == null) return;
//
//   _isLoading = true;
//   notifyListeners();
//
//   final routeFilterProvider = context.read<RouteFilterProvider>();
//   _busTimings = await _busTimingRepository.getBusTimings(
//     _currentStop!.stopId,
//     routeFilterProvider.selectedRoutes,
//   );
//
//   _isLoading = false;
//   notifyListeners();
// }
}
