import 'dart:math';

import 'package:flutter/material.dart';

class PlayerDraggable extends StatefulWidget {
  PlayerDraggable({Key? key}) : super(key: key);

  @override
  _PlayerDraggableState createState() =>
      _PlayerDraggableState(col: new Color.fromARGB(255, Random().nextInt(255), Random().nextInt(255), Random().nextInt(255)));
}

class _PlayerDraggableState extends State<PlayerDraggable> {
  Offset offset = Offset(0, 0);
  Color col;

  _PlayerDraggableState({required this.col});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            offset = Offset(offset.dx + details.delta.dx, offset.dy + details.delta.dy);
          });
        },
        child: Container(width: 100, height: 100, color: Colors.blue),
      ),
    );
  }
}
