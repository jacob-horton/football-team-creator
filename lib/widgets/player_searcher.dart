import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/selected_player/selected_player_bloc.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/widgets/player_list_item.dart';
import 'package:provider/provider.dart';

import 'input_box.dart';

class PlayerSearcher extends StatefulWidget {
  @override
  _PlayerSearcherState createState() => _PlayerSearcherState();

  final bool multiselect;
  final void Function() onSelect;
  final void Function() onCancel;

  PlayerSearcher({Key? key, required this.onSelect, required this.onCancel, required this.multiselect}) : super(key: key);
}

class _PlayerSearcherState extends State<PlayerSearcher> {
  String searchValue = '';

  @override
  // TODO: Maintain selection on saving player / creating new player
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 25, bottom: 15, right: 20),
      child: BlocBuilder<SelectedPlayersBloc, SelectedPlayersState>(
        builder: (context, state) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InputBox(
                      hint: 'Search',
                      icon: Icons.search,
                      onChanged: (value) => setState(() => searchValue = value),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: GestureDetector(
                      child: Icon(Icons.add),
                      onTap: () => BlocProvider.of<SelectedPlayersBloc>(context, listen: false).add(NewPlayer()),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder<List<Player>>(
                  stream: Provider.of<PlayerDao>(context).watchAllPlayers(nameFilter: searchValue),
                  builder: (context, snapshot) {
                    final players = snapshot.data ?? [];
                    // TODO: Scroll to selected position
                    return ListView.separated(
                      padding: const EdgeInsets.only(top: 15),
                      itemBuilder: (context, index) {
                        bool isSelected = false;
                        if (state is SingleSelectionState) isSelected = players[index].id == state.selectedPlayer?.id;
                        if (state is NewPlayerState) isSelected = players[index].id == state.selectedPlayer?.id;
                        else if (state is MultiSelectionState) isSelected = state.players.any((player) => player.id == players[index].id);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.blue.withOpacity(isSelected ? 0.15 : 0),
                            ),
                            child: PlayerListItem(
                              player: players[index],
                              onTap: (p) {
                                EditablePlayer player = EditablePlayer.fromPlayer(p);
                                SelectedPlayersEvent event;
                                if (widget.multiselect) {
                                  if (state is MultiSelectionState && state.players.any((p) => p.id == player.id))
                                    event = RemoveSelectedPlayer(player: player);
                                  else
                                    event = AddSelectedPlayer(player: player);
                                } else
                                  event = SetSelectedPlayer(player: player);
                                BlocProvider.of<SelectedPlayersBloc>(context, listen: false).add(event);
                              },
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => Divider(height: 0),
                      itemCount: players.length,
                    );
                  },
                ),
              ),
              Row(
                children: [
                  _buildSelectButton(context, state),
                  Expanded(child: Container()),
                  TextButton(child: Text('CANCEL'), onPressed: widget.onCancel),
                  Padding(padding: const EdgeInsets.only(left: 15.0)),
                  TextButton(child: Text('SELECT'), onPressed: widget.onSelect),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSelectButton(BuildContext context, SelectedPlayersState state) {
    if (widget.multiselect) {
      bool isAnythingSelected = state is MultiSelectionState && state.players.length != 0;
      if (!isAnythingSelected) return Container();

      return TextButton(
        child: Text('DESELECT ALL'),
        onPressed: () => BlocProvider.of<SelectedPlayersBloc>(context).add(ClearSelectedPlayer()),
      );
    } else
      return Container();
  }
}
