import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/formation_bloc.dart';
import 'package:football/models/player.dart';
import 'package:football/pages/player_selector.dart';
import 'package:window_size/window_size.dart';

class PlayerDraggable extends StatefulWidget {
  final Player player;

  PlayerDraggable({Key? key, required this.player}) : super(key: key);

  @override
  _PlayerDraggableState createState() =>
      _PlayerDraggableState(col: new Color.fromARGB(255, Random().nextInt(255), Random().nextInt(255), Random().nextInt(255)));
}

class _PlayerDraggableState extends State<PlayerDraggable> {
  static const double size = 90;

  //Size previousSize = Size(1, 1);
  Offset offset = Offset(50, 50);
  Color col;

  _PlayerDraggableState({required this.col});

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
          color: widget.player.col,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.player.name.split(' ').last.toUpperCase()),
                Text(widget.player.number.toString()),
              ],
            ),
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
