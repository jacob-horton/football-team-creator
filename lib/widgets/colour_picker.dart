

import 'package:flutter/material.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/utils/shirt_colours.dart';
import 'package:football/widgets/shirt.dart';

class ColourPicker extends StatefulWidget {
  final Player player;
  final TextEditingController? controller;

  ColourPicker({Key? key, required this.player, this.controller}) : super(key: key) {
    controller?.text = player.colour;
  }

  @override
  _ColourPickerState createState() => _ColourPickerState(player);
}

class _ColourPickerState extends State<ColourPicker> {
  String? currentColour;

  _ColourPickerState(Player player) {
    currentColour = player.colour;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Shirt(size: 150, colour: currentColour),
        Container(
          width: 125,
          height: 80,
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            children: ShirtColours.colours.keys
                .map(
                  (key) => GestureDetector(
                    onTap: () {
                      widget.controller?.text = key;
                      setState(() => currentColour = key);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.black,
                          width: 3,
                          style: key == currentColour ? BorderStyle.solid : BorderStyle.none,
                        ),
                        color: ShirtColours.colours[key],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
