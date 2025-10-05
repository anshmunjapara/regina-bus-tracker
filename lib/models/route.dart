import 'package:latlong2/latlong.dart';

class RouteInfo {
  final String routeNumber; // <- top-level key from JSON
  final String name;
  final String color;
  final Map<String, String> lines;
  final List<LatLng> points;

  RouteInfo({
    required this.routeNumber,
    required this.name,
    required this.color,
    required this.lines,
    this.points = const [], // Initialize as empty
  });

  // Add a method to create a new instance with updated points
  RouteInfo copyWith({List<LatLng>? points}) {
    return RouteInfo(
      routeNumber: routeNumber,
      name: name,
      color: color,
      lines: lines,
      points: points ?? this.points,
    );
  }

  factory RouteInfo.fromJson(String routeNumber, Map<String, dynamic> json) {
    final Map<String, String> linesMap =
        (json['lines'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, value as String),
    );

    return RouteInfo(
      routeNumber: routeNumber,
      name: json['name'] as String,
      color: json['color'] as String,
      lines: linesMap,
    );
  }
}

Map<String, RouteInfo> parseRoutes(Map<String, dynamic> json) {
  return json
      .map((key, value) => MapEntry(key, RouteInfo.fromJson(key, value)));
}
