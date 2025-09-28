class RouteInfo {
  final String routeNumber; // <- top-level key from JSON
  final String name;
  final String color;
  final Map<String, String> lines;

  RouteInfo({
    required this.routeNumber,
    required this.name,
    required this.color,
    required this.lines,
  });

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
  return json.map((key, value) => MapEntry(key, RouteInfo.fromJson(key, value)));
}
