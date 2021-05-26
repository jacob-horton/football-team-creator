import 'package:flutter/material.dart';
import 'package:football/utils/shirt_colours.dart';
import 'package:football/widgets/shirt.dart';

class ColourPicker extends StatefulWidget {
  final Function(String colour) onTap;
  final String initialColour;

  ColourPicker({Key? key, required this.onTap, required this.initialColour}) : super(key: key);

  @override
  _ColourPickerState createState() => _ColourPickerState(initialColour);
}

class _ColourPickerState extends State<ColourPicker> {
  String colour;

  _ColourPickerState(this.colour);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Shirt(size: 150, colour: colour),
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
                      setState(() => colour = key);
                      widget.onTap(key);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.black,
                          width: 3,
                          style: key == colour ? BorderStyle.solid : BorderStyle.none,
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
