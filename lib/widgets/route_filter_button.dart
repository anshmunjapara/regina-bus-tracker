import 'package:bus_tracker/widgets/route_filter_overlay.dart';
import 'package:flutter/material.dart';

class RouteFilterButton extends StatelessWidget {
  const RouteFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(50.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              spreadRadius: 1,
              blurRadius: 20,
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.filter_list, size: 30),
          color: Colors.blueAccent,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => const RouteFilterOverlay(),
            );
          },
        ),
      ),
    );
  }
}
