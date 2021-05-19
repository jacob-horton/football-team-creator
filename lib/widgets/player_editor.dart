import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/current_player/selected_player_bloc.dart';
import 'package:football/bloc/formation/formation_bloc.dart';
import 'package:football/data/moor_database.dart';
import 'package:moor/moor.dart' hide Column;
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
    // TODO: fix selection when adding new players
    return BlocBuilder<SelectedPlayersBloc, SelectedPlayersState>(
      builder: (context, state) {
        _clearFields();
        if (state is SingleSelectionState || (state is MultiSelectionState && state.selected != null)) {
          Player player = (state is SingleSelectionState) ? state.player : (state as MultiSelectionState).selected as Player;

          return _buildEditor(
            context,
            onSave: () {
              Provider.of<PlayerDao>(context, listen: false).updatePlayer(
                player.copyWith(
                  colour: colourController.text,
                  name: nameController.text,
                  number: int.parse(numberController.text),
                  score: int.parse(scoreController.text),
                  preferedPosition: int.parse(preferredPositionController.text),
                ),
              );
              _clearFields();
              BlocProvider.of<FormationBloc>(context, listen: false).add(LoadPositions());
            },
            onDelete: () {
              // TODO: Need to delete player from team before deleting from database
              Provider.of<PlayerDao>(context, listen: false).deletePlayer(player);
              BlocProvider.of<FormationBloc>(context, listen: false).add(RemovePlayer(player: player));
              BlocProvider.of<SelectedPlayersBloc>(context, listen: false).add(ClearSelectedPlayer());
              Provider.of<PlayerDao>(context, listen: false).deletePlayer(player);
            },
            name: player.name,
            colour: player.colour,
            number: player.number,
            score: player.score,
            preferredPosition: player.preferedPosition,
          );
        } else if (state is NewPlayerState) {
          return _buildEditor(
            context,
            onSave: () async {
              final playerDao = Provider.of<PlayerDao>(context, listen: false);
              final id = await playerDao.insertPlayer(
                PlayersCompanion(
                  colour: Value(colourController.text),
                  name: Value(nameController.text),
                  number: Value(int.parse(numberController.text)),
                  score: Value(int.parse(scoreController.text)),
                  preferedPosition: Value(int.parse(preferredPositionController.text)),
                ),
              );

              BlocProvider.of<FormationBloc>(context, listen: false).add(LoadPositions());
              BlocProvider.of<SelectedPlayersBloc>(context, listen: false).add(AddSelectedPlayer(player: await playerDao.getPlayer(id)));
            },
          );
        } else
          return Center(child: Text('Player not selected', style: Theme.of(context).textTheme.caption));
      },
    );
  }

  _clearFields() {
    nameController.clear();
    scoreController.clear();
    colourController.clear();
    numberController.clear();
    preferredPositionController.clear();
  }

  Padding _buildEditor(
    BuildContext context, {
    required Function() onSave,
    Function()? onDelete,
    String? colour,
    String? name,
    int? number,
    int? score,
    int? preferredPosition,
  }) {
    if (name != null) nameController.text = name;
    if (number != null) numberController.text = number.toString();
    if (score != null) scoreController.text = score.toString();
    if (preferredPosition != null) preferredPositionController.text = preferredPosition.toString();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.only(top: 10.0)),
          ColourPicker(colour: colour, controller: colourController),
          Padding(padding: const EdgeInsets.only(top: 25.0)),
          _buildField('Name', nameController),
          Padding(padding: const EdgeInsets.only(top: 5.0)),
          Row(
            children: [
              Expanded(child: _buildField('Number', numberController)), // TODO: Only accept numbers
              Padding(padding: const EdgeInsets.only(left: 20.0)),
              Expanded(child: _buildField('Score', scoreController)), // TODO: Only accept numbers
            ],
          ),
          Padding(padding: const EdgeInsets.only(top: 5.0)),
          Expanded(child: _buildField('Preferred Position', preferredPositionController)), // TODO: Make dropdown
          Row(
            children: [
              onDelete == null
                  ? Container()
                  : TextButton(
                      child: Text('DELETE'),
                      onPressed: onDelete,
                    ),
              Expanded(child: Container()),
              TextButton(
                child: Text('SAVE'),
                onPressed: onSave,
              ),
            ],
          ),
        ],
      ),
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
