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
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              spreadRadius: 1,
              blurRadius: 20,
            ),
          ],
        ),
        child: TextButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => const RouteFilterOverlay(),
            );
          },
          child: const Text('Routes', style: TextStyle(color: Colors.black),),
        ),
        // IconButton(
        //   icon: const Icon(Icons.filter_list, size: 30),
        //   tooltip: 'Filter routes',
        //
        //   color: Colors.blueAccent,
        //   onPressed: () {
        //     showModalBottomSheet(
        //       context: context,
        //       shape: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        //       ),
        //       builder: (context) => const RouteFilterOverlay(),
        //     );
        //   },
        // ),
      ),
    );
  }
}
