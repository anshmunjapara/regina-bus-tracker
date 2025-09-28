import 'dart:convert';
import 'package:bus_tracker/models/stop.dart';
import 'package:http/http.dart' as http;

import '../models/bus.dart';

class ApiService {
  static const String baseUrl = "https://transitlive.com/json";

  Future<String> fetchBusesJson() async {
    final response = await http.get(Uri.parse('$baseUrl/buses.js'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to load buses from API");
    }
  }

  Future<String> fetchStopsJson() async {
    final response = await http.get(Uri.parse('$baseUrl/stops.js'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to load stops from API");
    }
  }

  Future<String> fetchRoutesJson() async {
    final response = await http.get(Uri.parse('$baseUrl/routes.js'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to load routes from API");
    }
  }
}
