import 'package:bus_tracker/models/bus_timings.dart';
import 'package:flutter/material.dart';

import '../models/stop.dart';

class StopDetailsBottomSheet extends StatelessWidget {
  final Stop stop;
  final List<BusTiming> busTimings;

  const StopDetailsBottomSheet({
    super.key,
    required this.stop,
    required this.busTimings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      height: 300.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${stop.stopId} : ${stop.name}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            'Routes: ${stop.routes}',
            style: const TextStyle(
              color: Colors.black54,
              height: 0.9,
            ),
          ),
          const SizedBox(height: 20),
          busTimings.isEmpty
              ? const Expanded(child: Text('No bus timings available'))
              : _buildBusTimings(),
        ],
      ),
    );
  }

  Widget _buildBusTimings() {
    return Expanded(
      child: ListView.builder(
        itemCount: busTimings.length,
        itemBuilder: (context, index) {
          final timing = busTimings[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.directions_bus),
              title: Text('Route ${timing.route} to ${timing.routeName}'),
              subtitle: Text('Arriving at ${timing.eta}'),
            ),
          );
        },
      ),
    );
  }
}
