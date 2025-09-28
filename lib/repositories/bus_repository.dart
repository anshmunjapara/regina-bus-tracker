import 'dart:convert';

import 'package:bus_tracker/models/bus.dart';
import 'package:bus_tracker/services/api_service.dart';

class BusRepository {
  final ApiService _apiService = ApiService();

  Future<List<Bus>> getAllBuses() async {
    final jsonString = await _apiService.fetchBusesJson();
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Bus.fromJson(json)).toList();
  }

  Future<Bus?> getBusByID(Bus currBus) async {
    final buses = await getAllBuses();
    try {
      return buses.firstWhere((bus) => bus.busId == currBus.busId);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
