import 'package:bus_tracker/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../models/bus.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../models/route.dart';
import '../providers/bus_provider.dart';
import '../providers/map_provider.dart';
import '../providers/route_filter_provider.dart';
import '../utils/StopMarker.dart';
import '../utils/bus_marker.dart';

class MapWidget extends StatelessWidget {
  final Function(Bus) onBusTap;
  final MapController? mapController;

  const MapWidget({
    super.key,
    required this.onBusTap,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        return FlutterMap(
          mapController: mapController,
          options: _buildMapOptions(mapProvider),
          children: [
            _buildTileLayer(),
            _buildPolylineLayer(),
            _buildStopMarkers(),
            _buildBusMarkers(),
          ],
        );
      },
    );
  }

  MapOptions _buildMapOptions(MapProvider mapProvider) {
    return MapOptions(
      initialCenter: const LatLng(50.4452, -104.6189),
      // Regina center
      minZoom: 11.0,
      maxZoom: 17.0,
      cameraConstraint: CameraConstraint.contain(
        bounds: LatLngBounds(
          const LatLng(50.38, -104.75), // South-West
          const LatLng(50.52, -104.50), // North-East
        ),
      ),

      onMapReady: () => mapProvider.onMapPositionChanged(mapController!.camera),
      onPositionChanged: (camera, hasGesture) {
        if (hasGesture) {
          mapProvider.onMapPositionChanged(camera);
        }
      },
    );
  }

  Widget _buildTileLayer() {
    return TileLayer(
      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      userAgentPackageName: 'com.example.bus_tracker',
    );
  }

  Widget _buildStopMarkers() {
    return Consumer<MapProvider>(
      builder: (context, provider, child) {
        return MarkerLayer(
          markers: provider.visibleStops
              .map((stop) => buildStopMarker(stop))
              .toList(),
        );
      },
    );
  }

  Widget _buildBusMarkers() {
    return Consumer2<BusProvider, RouteFilterProvider>(
      builder: (context, busProvider, routeFilterProvider, child) {
        final selectedRoutes = routeFilterProvider.selectedRoutes;

        final filteredBuses = selectedRoutes.isEmpty
            ? busProvider.buses
            : busProvider.buses
                .where((bus) => selectedRoutes.contains(bus.route.toString()))
                .toList();

        return MarkerLayer(
          markers: filteredBuses.map((bus) {
            final route = busProvider.routes[bus.route.toString()];
            final color = route != null ? route.color.toColor() : Colors.grey;
            return buildBusMarker(bus, color, () => onBusTap(bus));
          }).toList(),
        );
      },
    );
  }

  Widget _buildPolylineLayer() {
    return Consumer<RouteFilterProvider>(builder: (context, provider, child) {
      final polylinesToDraw = <Polyline>[];
      final Map<String, RouteInfo> routes = context.read<BusProvider>().routes;

      final routesToDraw = routes.values.where(
          (route) => provider.selectedRoutes.contains(route.routeNumber));

      for (final route in routesToDraw) {
        if (route.points.isNotEmpty) {
          polylinesToDraw.add(Polyline(
            points: route.points,
            strokeWidth: 4,
            color: route.color.toColor(),
          ));
        }
      }
      return PolylineLayer(polylines: polylinesToDraw);
    });
  }
}
