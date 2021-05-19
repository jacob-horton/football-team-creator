import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/selected_player/selected_player_bloc.dart';
import 'package:football/utils/shirt_colours.dart';
import 'package:football/widgets/shirt.dart';

class ColourPicker extends StatelessWidget {
  final SelectedPlayersState state;
  ColourPicker({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Shirt(size: 150, colour: state.selectedPlayer?.colour),
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
                    onTap: () => BlocProvider.of<SelectedPlayersBloc>(context, listen: false)
                        .add(SetSelectedPlayer(player: (state.selectedPlayer as EditablePlayer).copyWith(colour: key))),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.black,
                          width: 3,
                          style: key == state.selectedPlayer?.colour ? BorderStyle.solid : BorderStyle.none,
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
