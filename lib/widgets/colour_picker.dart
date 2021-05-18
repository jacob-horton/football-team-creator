import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/current_player/selected_player_bloc.dart';
import 'package:football/utils/shirt_colours.dart';
import 'package:football/widgets/shirt.dart';

class ColourPicker extends StatefulWidget {
  final String? colour;
  final TextEditingController? controller;

  ColourPicker({Key? key, required this.colour, this.controller}) : super(key: key) {
    controller?.text = colour ?? '';
  }

  @override
  _ColourPickerState createState() => _ColourPickerState(colour ?? '');
}

class _ColourPickerState extends State<ColourPicker> {
  String? currentColour;

  _ColourPickerState(String colour) {
    currentColour = colour;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedPlayersBloc, SelectedPlayersState>(
      builder: (context, state) {
        // TODO: Update colour on different player selected
        // Below didn't work as it stopped UI updating when user selects different colour

        //if (state is SingleSelectionState) currentColour = state.player.colour;
        //else if (state is MultiSelectionState) currentColour = state.selected?.colour;

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
      },
    );
  }
}
