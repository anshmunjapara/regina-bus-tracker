class Stop {
  final String stopId;
  final String name;
  final List<int> routes;
  final String dir;
  final double latitude;
  final double longitude;

  Stop({
    required this.stopId,
    required this.name,
    required this.routes,
    required this.dir,
    required this.latitude,
    required this.longitude,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    final properties = json['properties'] as Map<String, dynamic>;
    final geometry = json['geometry'] as Map<String, dynamic>;
    final coords = geometry['coordinates'] as List<dynamic>;

    return Stop(
      stopId: properties['id'] as String,
      name: properties['name'] as String,
      routes: (properties['r'] as List<dynamic>).map((e) => e as int).toList(),
      dir: properties['dir'],
      longitude: double.parse(coords[0].toString()), // JSON stores as string
      latitude: double.parse(coords[1].toString()),
    );
  }
}

List<Stop> parseStops(List<dynamic> jsonList) {
  return jsonList.map((item) => Stop.fromJson(item)).toList();
}
