import 'package:bus_tracker/models/stop.dart';
import 'package:bus_tracker/providers/bus_provider.dart';
import 'package:bus_tracker/providers/map_provider.dart';
import 'package:bus_tracker/widgets/route_filter_button.dart';
import 'package:bus_tracker/widgets/stop_details_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

import '../models/bus.dart';
import '../providers/bus_timing_provider.dart';
import '../services/bus_tracking_service.dart';
import '../widgets/bus_details_bottom_sheet.dart';
import '../widgets/map_widget.dart';
import '../widgets/app_bottom_sheet.dart';

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
    _trackingService.isTracking.dispose();
    super.dispose();
  }

  void _handleBusTap(Bus bus) {
    _showBusDetailsBottomSheet(bus);
  }

  void _showBusDetailsBottomSheet(Bus bus) {
    showAppBottomSheet(
      context,
      BusDetailsBottomSheet(
        bus: bus,
        onTrackBus: () => _startBusTracking(bus),
        onCancel: () => Navigator.of(context).pop(),
      ),
      isScrollControlled: false,
    );
  }

  Future<void> _handleStopTap(Stop stop) async {
    // final routeFilterProvider = context.read<RouteFilterProvider>();
    final busTimingProvider = context.read<BusTimingProvider>();
    await busTimingProvider.loadBusTimings(context, stop);
    _showStopDetails(stop);
  }

  void _showStopDetails(Stop stop) {
    showAppBottomSheet(
      context,
      StopDetailsBottomSheet(stop: stop),
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
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _trackingService.isTracking,
        builder: (context, isTracking, child) {
          if (isTracking) {
            return FloatingActionButton.extended(
              heroTag: 'stop_tracking',
              backgroundColor: Colors.white,
              onPressed: _stopTrackingWithMessage,
              label: const Text(
                'Stop Tracking',
                style: TextStyle(color: Colors.black),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text("Regina Map"),
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
