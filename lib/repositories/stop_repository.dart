import 'dart:convert';

import 'package:bus_tracker/services/api_service.dart';

import '../config/service_locator.dart';
import '../models/stop.dart';

class StopRepository {
  final ApiService _apiService = getIt<ApiService>();

  Future<List<Stop>> getAllStops() async {
    final jsonString = await _apiService.fetchStopsJson();
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Stop.fromJson(json)).toList();
  }
}
