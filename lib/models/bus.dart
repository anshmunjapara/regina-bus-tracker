class Bus {
  final int busId; //bus id
  final int route; // route number
  final String line; // line name
  final int dir;  // bus dir
  final double latitude;
  final double longitude;

  Bus({
    required this.busId,
    required this.route,
    required this.line,
    required this.dir,
    required this.latitude,
    required this.longitude,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    final properties = json['properties'];
    final geometry = json['geometry'];

    return Bus(
      busId: properties['b'] as int,
      route: properties['r'] as int,
      line: properties['line'] as String,
      dir: properties['dir'] as int,
      latitude: double.parse(geometry['coordinates'][1]),
      longitude: double.parse(geometry['coordinates'][0]),
    );
  }
}

List<Bus> parseBusList(List<dynamic> jsonList) {
  return jsonList.map((item) => Bus.fromJson(item)).toList();
}
