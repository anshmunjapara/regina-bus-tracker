class BusTiming {
  final String eta;
  final int busID;
  final int route;
  final String routeName;

  BusTiming({
    required this.eta,
    required this.busID,
    required this.route,
    required this.routeName,
  });

  factory BusTiming.fromJson(Map<String, dynamic> json) {
    return BusTiming(
      eta: json['pred_time'] as String,
      busID: json['bus_id'] as int,
      route: json['route_id'] as int,
      routeName: json['line_name'] as String,
    );
  }
}

List<BusTiming> parseStops(List<dynamic> jsonList) {
  return jsonList.map((item) => BusTiming.fromJson(item)).toList();
}
