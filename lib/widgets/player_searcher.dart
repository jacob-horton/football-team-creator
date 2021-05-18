import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/current_player/current_player_bloc.dart';
import 'package:football/bloc/formation/formation_bloc.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/widgets/player_list_item.dart';
import 'package:moor/moor.dart' hide Column;
import 'package:provider/provider.dart';

import 'input_box.dart';

class PlayerSearcher extends StatelessWidget {
  final bool multiselect;
  final void Function() onSelect;
  final void Function() onCancel;

  PlayerSearcher({Key? key, required this.onSelect, required this.onCancel, required this.multiselect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 25, bottom: 15, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: InputBox(hint: 'Search', icon: Icons.search)),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: GestureDetector(
                  child: Icon(Icons.add),
                  onTap: () async {
                    int id = await Provider.of<PlayerDao>(context, listen: false).insertPlayer(
                      PlayersCompanion(
                        name: Value('Jacob Horton'),
                        colour: Value('blue'),
                        number: Value(2),
                        score: Value(7),
                        preferedPosition: Value(1),
                      ),
                    );
                    // TODO: Do not add player to a team here
                    BlocProvider.of<FormationBloc>(context, listen: false).add(
                      AddPlayer(
                        player: PlayerPositionsCompanion(
                          playerId: Value(id),
                          team: Value(2), // TODO: Assign team
                          x: Value(100),
                          y: Value(200),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<List<Player>>(
              stream: Provider.of<PlayerDao>(context).watchAllPlayers(),
              builder: (context, snapshot) {
                final players = snapshot.data ?? [];
                return BlocBuilder<CurrentPlayerBloc, CurrentPlayerState>(
                  builder: (context, state) {
                    // TODO: Scroll to selected position
                    return ListView.separated(
                      padding: const EdgeInsets.only(top: 15),
                      itemBuilder: (context, index) {
                        bool isSelected = false;
                        if (state is PlayerSelectedState) isSelected = players[index].id == state.player.id;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.blue.withOpacity(isSelected ? 0.15 : 0),
                            ),
                            child: PlayerListItem(
                              player: players[index],
                              onTap: (player) =>
                                  BlocProvider.of<CurrentPlayerBloc>(context, listen: false).add(SetCurrentPlayer(player: player)),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => Divider(height: 0),
                      itemCount: players.length,
                    );
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(child: Text('CANCEL'), onPressed: onCancel),
              Padding(padding: const EdgeInsets.only(left: 15.0)),
              TextButton(child: Text('SELECT'), onPressed: onSelect),
            ],
          ),
        ],
      ),
    );
  }
}
