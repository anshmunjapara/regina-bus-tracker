import 'package:bus_tracker/models/stop.dart';

class ProcessedStop {
  final int id;
  final String name;
  final double distanceAlongRoute;

  ProcessedStop({
    required this.id,
    required this.name,
    required this.distanceAlongRoute,
  });

  factory ProcessedStop.fromJson(Map<String, dynamic> json) {
    return ProcessedStop(
      id: int.parse(json['id']),
      name: json['name'] as String,
      distanceAlongRoute: (json['distance']).toDouble(),
    );
  }
}
