import 'package:bus_tracker/providers/bus_provider.dart';
import 'package:bus_tracker/providers/bus_timing_provider.dart';
import 'package:bus_tracker/utils/string_extensions.dart';
import 'package:bus_tracker/widgets/expand_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/route.dart';
import '../models/stop.dart';
import '../providers/route_filter_provider.dart';

class StopDetailsBottomSheet extends StatelessWidget {
  final Stop stop;

  const StopDetailsBottomSheet({
    super.key,
    required this.stop,
  });

  @override
  Widget build(BuildContext context) {
    final routes = context.read<BusProvider>().routes;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: ExpandBar()),
          const SizedBox(height: 10),
          _buildTitle(),
          const SizedBox(height: 10),
          _buildRouteButtons(context, routes),
          const SizedBox(height: 20),
          Expanded(child: _buildBusTimings(routes)),
        ],
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      '${stop.stopId} : ${stop.name}',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  Widget _buildRouteButtons(
      BuildContext context, Map<String, RouteInfo> routes) {
    return Wrap(
      spacing: 6, // horizontal space between tags
      runSpacing: 6, // vertical space when wrapping
      children: stop.routes.map<Widget>((route) {
        final selectedRoutes =
            context.watch<RouteFilterProvider>().selectedRoutes;
        final isSelected = selectedRoutes.contains(route.toString());
        final color = routes[route.toString()]?.color.toColor();
        return GestureDetector(
          onTap: () {
            context.read<RouteFilterProvider>().toggleRoute(route.toString());
            context.read<BusTimingProvider>().loadBusTimings(context, stop);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.grey,
              // border: Border.all(color: Colors.blueAccent, width: 1),
              borderRadius:
                  BorderRadius.circular(6), // for square look, use 4–6 radius
            ),
            child: Text(
              route.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBusTimings(Map<String, RouteInfo> routes) {
    return Consumer<BusTimingProvider>(
      builder: (context, busTimingProvider, child) {
        if (busTimingProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (busTimingProvider.busTimings.isEmpty) {
          return const Center(child: Text('No bus timings available.'));
        }
        return ListView.builder(
          itemCount: busTimingProvider.busTimings.length,
          itemBuilder: (context, index) {
            final timing = busTimingProvider.busTimings[index];
            final color = routes[timing.route.toString()]?.color.toColor();
            return Card(
              child: ListTile(
                leading: Icon(Icons.directions_bus, color: color),
                title: Text(
                    'Bus ${timing.route} (${timing.routeName}) #${timing.busID == 0 ? 'Scheduled' : timing.busID}'),
                subtitle: Text('Arriving at ${timing.eta}'),
              ),
            );
          },
        );
      },
    );
  }
}
