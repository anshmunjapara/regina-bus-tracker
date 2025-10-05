import 'package:bus_tracker/providers/route_filter_provider.dart';
import 'package:bus_tracker/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bus_tracker/providers/bus_provider.dart';

import '../models/route.dart';

class RouteFilterOverlay extends StatelessWidget {
  const RouteFilterOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, RouteInfo> routes = context.read<BusProvider>().routes;
    final Set<String> selectedRoutes =
        context.watch<RouteFilterProvider>().selectedRoutes;

    return Container(
      margin: const EdgeInsets.all(20.0),
      height: 400.0,
      decoration: const BoxDecoration(
        color: Colors.white38,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Routes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                ...routes.entries.map(
                  (entry) {
                    final String routeId = entry.key;
                    final RouteInfo routeInfo = entry.value;
                    final color = routeInfo.color.toColor();

                    final isSelected = selectedRoutes.contains(routeId);
                    return ListTile(
                      title:
                          Text('${routeInfo.routeNumber} - ${routeInfo.name}'),
                      // leading: isSelected
                      //     ? const Icon(Icons.check_circle, color: Colors.blueAccent)
                      //     : const Icon(Icons.radio_button_unchecked),
                      onTap: () {
                        context
                            .read<RouteFilterProvider>()
                            .toggleRoute(routeId);
                      },
                      selected: isSelected,
                      selectedTileColor: color.withAlpha(180),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
