import 'dart:convert';
import 'package:bus_tracker/models/stop.dart';
import 'package:http/http.dart' as http;

import '../models/bus.dart';

class ApiService {
  static const String baseUrl = "https://transitlive.com/json";

  static Future<List<Bus>> fetchBuses() async {
    final response = await http.get(Uri.parse('$baseUrl/buses.js'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return parseBusList(jsonList);
    } else {
      throw Exception("Failed to load buses");
    }
  }

  static  Future<Bus?> fetchBusById(Bus currBus) async{
    final buses = await fetchBuses();
    try {
      return buses.firstWhere((bus) => bus.busId == currBus.busId);
    } catch (e) {
      return null; // no bus found
    }
  }

  static Future<List<Stop>> fetchStops() async {
    final response = await http.get(Uri.parse('$baseUrl/stops.js'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return parseStops(jsonList);
    } else {
      throw Exception("Failed to load stops");
    }
  }
}