import 'dart:convert';

import '../config/service_locator.dart';
import '../models/bus_timings.dart';
import '../services/api_service.dart';

Future<List<BusTiming>> getBusTimings(stopId) async {
  final ApiService apiService = getIt<ApiService>();
  final jsonString = await apiService.fetchBusTimingsJson(stopId);
  final List<dynamic> jsonList = json.decode(jsonString);
  return parseStops(jsonList);
}
