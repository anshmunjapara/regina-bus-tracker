import 'dart:convert';

import '../config/service_locator.dart';
import '../models/processed_route_stop.dart';
import '../services/api_service.dart';

Future<Map<String, List<ProcessedStop>>> getAllProcessedStops() async {
  final ApiService apiService = getIt<ApiService>();
  final jsonString = await apiService.fetchAllProcessedStops();
  final Map<String, dynamic> data = json.decode(jsonString);
  final Map<String, List<ProcessedStop>> processedStopsMap = {};

  data.forEach((key, value) {
    final routeNumber = key;
    if (routeNumber != "") {
      final stopsList = (value as List)
          .map((stopData) => ProcessedStop.fromJson(stopData))
          .toList();
      processedStopsMap[routeNumber] = stopsList;
    }
  });

  return processedStopsMap;
}
