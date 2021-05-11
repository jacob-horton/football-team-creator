import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final double height;
  final double horizontalPadding;
  final double borderRadius;
  final Color colour;
  final Widget child;

  const RoundedContainer({
    Key? key,
    required this.colour,
    required this.child,
    this.height = 28.0,
    this.horizontalPadding = 10.0,
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: colour,
      ),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: child,
    );
  }
}
