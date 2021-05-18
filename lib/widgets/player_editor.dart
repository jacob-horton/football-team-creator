import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/current_player/current_player_bloc.dart';
import 'package:football/bloc/formation/formation_bloc.dart';
import 'package:football/data/moor_database.dart';
import 'package:provider/provider.dart';

import 'colour_picker.dart';
import 'input_box.dart';

class PlayerEditor extends StatelessWidget {
  PlayerEditor({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final scoreController = TextEditingController();
  final colourController = TextEditingController();
  final numberController = TextEditingController();
  final preferredPositionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentPlayerBloc, CurrentPlayerState>(
      builder: (context, state) {
        if (state is PlayerUnselectedState)
          return Center(child: Text('Player not selected', style: Theme.of(context).textTheme.caption));
        else if (state is PlayerSelectedState)
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.only(top: 10.0)),
                ColourPicker(player: state.player, controller: colourController),
                Padding(padding: const EdgeInsets.only(top: 25.0)),
                _buildField('Name', nameController..text = state.player.name),
                Padding(padding: const EdgeInsets.only(top: 5.0)),
                Row(
                  children: [
                    Expanded(child: _buildField('Number', numberController..text = state.player.number.toString())), // TODO: Only accept numbers
                    Padding(padding: const EdgeInsets.only(left: 20.0)),
                    Expanded(child: _buildField('Score', scoreController..text = state.player.score.toString())), // TODO: Only accept numbers
                  ],
                ),
                Padding(padding: const EdgeInsets.only(top: 5.0)),
                Expanded(
                    child: _buildField(
                        'Preferred Position', preferredPositionController..text = state.player.preferedPosition.toString())), // TODO: Make dropdown
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      child: Text('SAVE'),
                      onPressed: () {
                        Provider.of<PlayerDao>(context, listen: false).updatePlayer(
                          state.player.copyWith(
                            colour: colourController.text,
                            name: nameController.text,
                            number: int.parse(numberController.text),
                            score: int.parse(scoreController.text),
                            preferedPosition: int.parse(preferredPositionController.text),
                          ),
                        );
                        BlocProvider.of<FormationBloc>(context, listen: false).add(LoadPositions());
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        else
          return Center(child: Text('ERROR!'));
      },
    );
  }

  Widget _buildField(String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(hint),
        ),
        InputBox(controller: controller),
      ],
    );
  }
}