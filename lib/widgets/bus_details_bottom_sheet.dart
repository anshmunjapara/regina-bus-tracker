import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/bus.dart';

class BusDetailsBottomSheet extends StatelessWidget {
  final Bus bus;
  final VoidCallback onTrackBus;
  final VoidCallback onCancel;

  const BusDetailsBottomSheet({
    super.key,
    required this.bus,
    required this.onTrackBus,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      height: 300.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildAnimation(),
          _buildNotificationText(),
          const SizedBox(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Track Bus ${bus.route}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text(
                bus.line,
                style: const TextStyle(
                  color: Colors.black54,
                  height: 0.9,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildAnimation() {
    return Center(
      child: Lottie.asset('assets/data/bus_animation.json', width: 120),
    );
  }

  Widget _buildNotificationText() {
    return const Text('Receive arrival notifications?\n'
        'Estimated stop time: 20 minutes.');
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              side: const BorderSide(
                color: Colors.blue,
                width: 1.5,
              ),
            ),
            onPressed: onCancel,
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: onTrackBus,
            child: const Text(
              'Track',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
