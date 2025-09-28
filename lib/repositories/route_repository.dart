import 'dart:convert';

import 'package:bus_tracker/services/api_service.dart';

import '../models/route.dart';

class RouteRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, RouteInfo>> getAllRoutes() async {
    final jsonString = await _apiService.fetchRoutesJson();
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return parseRoutes(jsonMap);
  }
}
