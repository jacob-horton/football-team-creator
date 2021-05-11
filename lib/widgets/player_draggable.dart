import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:football/bloc/formation_bloc.dart';
import 'package:football/models/player.dart';
import 'package:football/pages/player_selector.dart';

class PlayerDraggable extends StatefulWidget {
  final Player player;

  PlayerDraggable({Key? key, required this.player}) : super(key: key);

  @override
  _PlayerDraggableState createState() => _PlayerDraggableState();
}

class _PlayerDraggableState extends State<PlayerDraggable> {
  static const double size = 120;
  final clipper = ShirtClip(size);

  //Size previousSize = Size(1, 1);
  Offset offset = Offset(50, 50);

  @override
  Widget build(BuildContext context) {
    //Size currentSize = MediaQuery.of(context).size;
    //if (currentSize != previousSize) {
    //  double xScale = currentSize.width / previousSize.width;
    //  double yScale = currentSize.height / previousSize.height;
//
    //  offset = Offset(offset.dx * xScale, offset.dy * yScale);
    //  previousSize = currentSize;
    //}

    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
        onTap: () => PlayerSelector(multiselect: false),
        onPanUpdate: (details) {
          setState(() {
            Size windowSize = MediaQuery.of(context).size;

            // Clamp to border of window
            double offX = _clamp(offset.dx + details.delta.dx, 0, windowSize.width - size);
            double offY = _clamp(offset.dy + details.delta.dy, 0, windowSize.height - size);

            // Correct offset when mouse moved outside window
            if (details.globalPosition.dx < 0) offX = 0;
            if (details.globalPosition.dy < 0) offY = 0;
            if (details.globalPosition.dx > windowSize.width) offX = windowSize.width - size;
            if (details.globalPosition.dy > windowSize.height) offY = windowSize.height - size;

            offset = Offset(offX, offY);
            BlocProvider.of<FormationBloc>(context).add(SetCustomFormation());
          });
        },
        child: Container(
          width: size,
          height: size,
          child: Stack(
            children: [
              ClipPath(
                clipper: clipper,
                child: SvgPicture.asset(
                  'assets/shirt.svg',
                  width: size,
                  height: size,
                  color: widget.player.col,
                  colorBlendMode: BlendMode.color,
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.player.name.split(' ').last.toUpperCase()),
                    Text(widget.player.number.toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}

class ShirtClip extends CustomClipper<Path> {
  late Path path;

  ShirtClip(double size) {
    path = Path();
    path.lineTo(size / 5, size * 0.08);
    path.cubicTo(size * 0.18, size * 0.08, size * 0.17, size * 0.08, size * 0.16, size * 0.09);
    path.cubicTo(size * 0.14, size * 0.1, size * 0.13, size * 0.12, size * 0.12, size * 0.13);
    path.cubicTo(size * 0.12, size * 0.13, size * 0.02, size * 0.3, size * 0.02, size * 0.3);
    path.cubicTo(-0.01, size * 0.36, size * 0.01, size * 0.43, size * 0.06, size * 0.46);
    path.cubicTo(size * 0.06, size * 0.46, size * 0.12, size * 0.49, size * 0.12, size * 0.49);
    path.cubicTo(size * 0.14, size / 2, size * 0.16, size * 0.51, size * 0.18, size * 0.51);
    path.cubicTo(size * 0.18, size * 0.51, size * 0.18, size * 0.82, size * 0.18, size * 0.82);
    path.cubicTo(size * 0.18, size * 0.87, size * 0.23, size * 0.92, size * 0.28, size * 0.92);
    path.cubicTo(size * 0.28, size * 0.92, size * 0.72, size * 0.92, size * 0.72, size * 0.92);
    path.cubicTo(size * 0.77, size * 0.92, size * 0.82, size * 0.87, size * 0.82, size * 0.82);
    path.cubicTo(size * 0.82, size * 0.82, size * 0.82, size * 0.51, size * 0.82, size * 0.51);
    path.cubicTo(size * 0.84, size * 0.51, size * 0.86, size / 2, size * 0.88, size * 0.49);
    path.cubicTo(size * 0.88, size * 0.49, size * 0.94, size * 0.46, size * 0.94, size * 0.46);
    path.cubicTo(size, size * 0.43, size, size * 0.36, size * 0.98, size * 0.3);
    path.cubicTo(size * 0.98, size * 0.3, size * 0.88, size * 0.13, size * 0.88, size * 0.13);
    path.cubicTo(size * 0.87, size * 0.12, size * 0.86, size * 0.1, size * 0.84, size * 0.09);
    path.cubicTo(size * 0.83, size * 0.08, size * 0.82, size * 0.08, size * 0.8, size * 0.08);
    path.cubicTo(size * 0.8, size * 0.08, size * 0.72, size * 0.08, size * 0.72, size * 0.08);
    path.cubicTo(size * 0.72, size * 0.08, size * 0.28, size * 0.08, size * 0.28, size * 0.08);
    path.cubicTo(size * 0.28, size * 0.08, size / 5, size * 0.08, size / 5, size * 0.08);
  }

  @override
  Path getClip(Size size) {
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
