import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://transitlive.com/json";
  final http.Client _client;

  ApiService({required http.Client client}) : _client = client;

  Future<String> fetchBusesJson() async {
    // final stopwatch = Stopwatch();
    // stopwatch.start();
    final response = await _client.get(Uri.parse('$baseUrl/buses.js'));

    if (response.statusCode == 200) {
      // stopwatch.stop();
      // print('✅API for bus call took ${stopwatch.elapsedMilliseconds}');
      return response.body;
    } else {
      throw Exception("Failed to load buses from API");
    }
  }

  Future<String> fetchStopsJson() async {
    final response = await _client.get(Uri.parse('$baseUrl/stops.js'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to load stops from API");
    }
  }

  Future<String> fetchRoutesJson() async {
    final response = await _client.get(Uri.parse('$baseUrl/routes.js'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to load routes from API");
    }
  }

  Future<String> fetchRoutePolylinesJson(String routeId) async {
    final response =
        await _client.get(Uri.parse('$baseUrl/polyLines/route$routeId.js'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to load route polyline from API");
    }
  }

  Future<String> fetchBusTimingsJson(
      String stopId, Set<String> selectedRoutes) async {
    String filter;
    if (selectedRoutes.isEmpty) {
      filter = '&routes=all';
    } else {
      filter = '&routes=${selectedRoutes.join(',')}';
    }
    final response = await _client.get(Uri.parse(
        'https://transitlive.com/ajax/livemap.php?action=stop_times&stop=$stopId$filter&lim=8&skip=0&ws=0'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to load bus timings from API");
    }
  }
}
