import 'package:bus_tracker/providers/route_filter_provider.dart';
import 'package:bus_tracker/utils/string_extensions.dart';
import 'package:bus_tracker/widgets/expand_bar.dart';
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ExpandBar(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select routes',
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
          const SizedBox(
            height: 10,
          ),
          SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  context.read<RouteFilterProvider>().clearFilters();
                },
                child: const Text(
                  'Clear Filters',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
