import 'dart:convert';

import 'package:bus_tracker/services/api_service.dart';
import 'package:latlong2/latlong.dart';

import '../config/service_locator.dart';
import '../models/route.dart';

class RouteRepository {
  final ApiService _apiService = getIt<ApiService>();

  Future<Map<String, RouteInfo>> getAllRoutes() async {
    final jsonString = await _apiService.fetchRoutesJson();
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final routes = parseRoutes(jsonMap);

    final polylineFutures = routes.keys.map((routeNumber) async {
      try {
        final String polylineJsonString;
        if (routeNumber == "9") {
          polylineJsonString =
              await _apiService.fetchPolylineFromMyServer(routeNumber);
        } else {
          polylineJsonString =
              await _apiService.fetchRoutePolylinesJson(routeNumber);
        }
        final points = parsePolyline(polylineJsonString);
        // Update the route object with its polyline points
        routes[routeNumber] = routes[routeNumber]!.copyWith(points: points);
      } catch (e) {
        print("Could not fetch or parse polyline for route $routeNumber: $e");
      }
    }).toList();

    await Future.wait(polylineFutures);

    return routes;
  }

  List<LatLng> parsePolyline(String polylineJsonString) {
    final json = jsonDecode(polylineJsonString);
    final coordinates = json['coordinates'] as List<dynamic>;
    return coordinates.map((coord) {
      return LatLng(coord[0] as double, coord[1] as double);
    }).toList();
  }
}
