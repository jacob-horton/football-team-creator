import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/formation/formation_bloc.dart';
import 'package:football/data/moor_database.dart';
import 'package:moor/moor.dart' hide Column;
import 'package:provider/provider.dart';

import 'input_box.dart';

class PlayerSearcher extends StatelessWidget {
  final bool multiselect;
  final void Function() onOk;
  final void Function() onCancel;

  const PlayerSearcher({Key? key, required this.onOk, required this.onCancel, required this.multiselect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 25, bottom: 25, right: 20),
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
                    return ListView(children: players.map((player) => Text(player.name)).toList());
                  })),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(child: Text('CANCEL'), onPressed: onOk),
              TextButton(child: Text('OK'), onPressed: onCancel),
            ],
          )
        ],
      ),
    );
  }
}
