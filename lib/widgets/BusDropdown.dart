import 'package:flutter/material.dart';
import '../models/bus.dart';

class BusDropdown extends StatelessWidget {
  final List<Bus> buses;
  final Bus? selectedBus;
  final ValueChanged<Bus?> onChanged;

  const BusDropdown({
    super.key,
    required this.buses,
    required this.selectedBus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Bus>(
      value: selectedBus,
      hint: const Text("Select a bus"),
      isExpanded: true,
      items: buses.map((bus) {
        return DropdownMenuItem<Bus>(
          value: bus,
          child: Text("Bus ${bus.route} - ${bus.line}"),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}