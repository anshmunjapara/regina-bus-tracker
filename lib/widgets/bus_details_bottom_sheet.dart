import 'package:bus_tracker/widgets/expand_bar.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: ExpandBar()),
          _buildTitle(),
          _buildAnimation(),
          _buildNotificationText(),
          const Spacer(),
          const SizedBox(height: 20),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildTitle() {
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
    return const Text(
        'Enable tracking to get real-time updates — you’ll receive notifications showing which stop this bus is approaching next.\n\n'
        'Tracking will automatically end after 20 minutes.');
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              side: BorderSide(
                color: Theme.of(context).splashColor,
                width: 1.5,
              ),
            ),
            onPressed: onCancel,
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).splashColor),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).splashColor,
            ),
            onPressed: onTrackBus,
            child: Text(
              'Track',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
