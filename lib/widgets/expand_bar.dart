import 'package:flutter/material.dart';

class ExpandBar extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final Color? color;

  const ExpandBar({
    super.key,
    this.width = 50,
    this.height = 5,
    this.padding = const EdgeInsets.all(8.0),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? Colors.grey[400],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}