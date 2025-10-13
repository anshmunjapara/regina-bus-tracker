import 'package:bus_tracker/models/bus_timings.dart';
import 'package:bus_tracker/models/stop.dart';
import 'package:bus_tracker/providers/bus_provider.dart';
import 'package:bus_tracker/providers/map_provider.dart';
import 'package:bus_tracker/widgets/route_filter_button.dart';
import 'package:bus_tracker/widgets/stop_details_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

import '../models/bus.dart';
import '../repositories/bus_timing_repository.dart';
import '../services/bus_tracking_service.dart';
import '../widgets/bus_details_bottom_sheet.dart';
import '../widgets/map_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  final MapController _mapController = MapController();
  final BusTrackingService _trackingService = BusTrackingService();

  @override
  void dispose() {
    _trackingService.stopTracking();
    super.dispose();
  }

  void _handleBusTap(Bus bus) {
    _showBusDetailsBottomSheet(bus);
  }

  void _showBusDetailsBottomSheet(Bus bus) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BusDetailsBottomSheet(
        bus: bus,
        onTrackBus: () => _startBusTracking(bus),
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<void> _handleStopTap(Stop stop) async {
    List<BusTiming> busTimings = await getBusTimings(stop.stopId);
    _showStopDetails(stop, busTimings);
  }

  void _showStopDetails(Stop stop, List<BusTiming> busTimings) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StopDetailsBottomSheet(
        stop: stop,
        busTimings: busTimings,
      ),
    );
  }

  void _startBusTracking(Bus bus) {
    final busProvider = context.read<BusProvider>();
    final allStops = context.read<MapProvider>().allStops;

    _trackingService.startTracking(bus, allStops, busProvider);
    Navigator.of(context).pop();
  }

  void _stopTrackingWithMessage() {
    _trackingService.stopTracking();
    _showSnackBar('Bus tracking stopped.');
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text("Regina Map"),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_off),
          onPressed: _stopTrackingWithMessage,
          tooltip: 'Stop bus tracking',
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer2<MapProvider, BusProvider>(
      builder: (context, mapProvider, busProvider, child) {
        if (_isLoading(mapProvider, busProvider)) {
          return _buildLoadingIndicator();
        }
        if (!busProvider.isProcessingComplete) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            busProvider.processAllRoutes(mapProvider.allStops);
          });
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing route data...'),
              ],
            ),
          );
        }

        return Stack(
          children: [
            MapWidget(
              onBusTap: _handleBusTap,
              onStopTap: _handleStopTap,
              mapController: _mapController,
            ),
            const RouteFilterButton()
          ],
        );
      },
    );
  }

  bool _isLoading(MapProvider mapProvider, BusProvider busProvider) {
    return mapProvider.isLoading || busProvider.isLoading;
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading map data...'),
        ],
      ),
    );
  }
}
