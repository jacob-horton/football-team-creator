import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/selected_player/selected_player_bloc.dart';
import 'package:football/bloc/formation/formation_bloc.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/widgets/rounded_container.dart';
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

  final List<String> positions = ['Defense', 'Midfield', 'Attack'];

  @override
  Widget build(BuildContext context) {
    // TODO: fix selection when adding new players
    return BlocBuilder<SelectedPlayersBloc, SelectedPlayersState>(
      builder: (context, state) {
        _clearFields();

        if (!(state is PlayerUnselectedState)) {
          return _buildEditor(
            context,
            state: state,
            onSave: () async {
              // TODO: Move updating to bloc
              final player = PlayersCompanion(
                id: state.selectedPlayer?.id == null ? Value.absent() : Value(state.selectedPlayer?.id as int),
                colour: state.selectedPlayer?.colour == null ? Value.absent() : Value(state.selectedPlayer?.colour as String),
                name: state.selectedPlayer?.name == null ? Value.absent() : Value(state.selectedPlayer?.name as String),
                number: state.selectedPlayer?.number == null ? Value.absent() : Value(state.selectedPlayer?.number as int),
                score: state.selectedPlayer?.score == null ? Value.absent() : Value(state.selectedPlayer?.score as int),
                preferedPosition:
                    state.selectedPlayer?.preferredPosition == null ? Value.absent() : Value(state.selectedPlayer?.preferredPosition as int),
              );

              if (state is NewPlayerState) {
                int id = await Provider.of<PlayerDao>(context, listen: false).insertPlayer(player);
                state.selectedPlayer?.id = id;
              } else
                Provider.of<PlayerDao>(context, listen: false).updatePlayer(player);
              BlocProvider.of<FormationBloc>(context, listen: false).add(LoadPositions());
            },
            onDelete: () {
              Provider.of<PlayerDao>(context, listen: false).deletePlayerFromID(state.selectedPlayer?.id as int);
              BlocProvider.of<FormationBloc>(context, listen: false)
                  .add(RemovePlayer(player: state.selectedPlayer?.toPlayer() as Player, windowSize: MediaQuery.of(context).size));
              BlocProvider.of<SelectedPlayersBloc>(context, listen: false).add(ClearSelectedPlayer());
            },
            player: state.selectedPlayer as EditablePlayer,
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
    required SelectedPlayersState state,
    required Function() onSave,
    required EditablePlayer player,
    Function()? onDelete,
  }) {
    _updateController(nameController, player.name);
    _updateController(colourController, player.colour);
    _updateController(scoreController, player.score);
    _updateController(numberController, player.number);
    _updateController(preferredPositionController, player.preferredPosition);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(padding: const EdgeInsets.only(top: 10.0)),
          ColourPicker(state: state),
          Padding(padding: const EdgeInsets.only(top: 25.0)),
          _buildField(
            'Name',
            nameController,
            (name) => // nameController.text = name,
                BlocProvider.of<SelectedPlayersBloc>(context)
                    .add(SetSelectedPlayer(player: state.selectedPlayer?.copyWith(name: name) as EditablePlayer)),
          ),
          Padding(padding: const EdgeInsets.only(top: 5.0)),
          Row(
            children: [
              Expanded(
                child: _buildField(
                    'Number',
                    numberController,
                    (number) => BlocProvider.of<SelectedPlayersBloc>(context)
                        .add(SetSelectedPlayer(player: state.selectedPlayer?.copyWith(number: int.parse(number)) as EditablePlayer))),
              ), // TODO: Only accept numbers
              Padding(padding: const EdgeInsets.only(left: 20.0)),
              Expanded(
                child: _buildField(
                    'Score',
                    scoreController,
                    (score) => BlocProvider.of<SelectedPlayersBloc>(context)
                        .add(SetSelectedPlayer(player: state.selectedPlayer?.copyWith(score: int.parse(score)) as EditablePlayer))),
              ), // TODO: Only accept numbers
            ],
          ),
          Padding(padding: const EdgeInsets.only(top: 20.0)),
          RoundedContainer(
            colour: Colors.white,
            height: 40.0,
            child: DropdownButton(
              value: state.selectedPlayer?.preferredPosition as int,
              dropdownColor: Colors.white,
              underline: Container(),
              items: _mapIndexed(
                positions,
                (index, value) => DropdownMenuItem(
                  child: Text(
                    value as String,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 20.0),
                  ),
                  value: index,
                ),
              ).toList(),
              onChanged: (index) {
                BlocProvider.of<SelectedPlayersBloc>(context)
                    .add(SetSelectedPlayer(player: state.selectedPlayer?.copyWith(preferredPosition: index as int) as EditablePlayer));
              },
              iconEnabledColor: Colors.black,
              icon: Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: Container()),
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

  Widget _buildField(String hint, TextEditingController controller, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(hint),
        ),
        InputBox(controller: controller, onChanged: onChanged),
      ],
    );
  }

  _updateController(TextEditingController controller, Object? newValue, {bool clearIfNull = false}) {
    if (newValue == null) {
      if (clearIfNull)
        newValue = '';
      else
        return;
    }

    controller.value = TextEditingValue(
      text: newValue.toString(),
      selection: TextSelection.fromPosition(
        TextPosition(offset: newValue.toString().length),
      ),
    );
  }

  Iterable<E> _mapIndexed<E, T>(Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }
}
