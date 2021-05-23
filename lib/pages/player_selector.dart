import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/selected_player/selected_player_bloc.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/widgets/player_editor.dart';
import 'package:football/widgets/player_searcher.dart';

class PlayerSelector extends StatelessWidget {
  final bool multiselect;
  final List<Player> initialPlayers;

  PlayerSelector({Key? key, required this.multiselect, required this.initialPlayers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: BlocProvider(
        create: (_) => SelectedPlayersBloc(initialPlayers),
        child: Row(
          children: [
            Flexible(
              child: BlocBuilder<SelectedPlayersBloc, SelectedPlayersState>(
                builder: (context, state) {
                  return PlayerSearcher(
                    onSelect: () {
                      if (state is SingleSelectionState)
                        Navigator.of(context).pop(state.selectedPlayer);
                      else if (state is NewPlayerState)
                        Navigator.of(context).pop(state.selectedPlayer);
                      else if (state is MultiSelectionState)
                        Navigator.of(context).pop(state.players);
                      else
                        Navigator.of(context).pop();
                    },
                    onCancel: () => Navigator.of(context).pop(),
                    multiselect: multiselect,
                  );
                },
              ),
              flex: 7,
            ),
            VerticalDivider(width: 0, endIndent: 10, indent: 10),
            Flexible(child: PlayerEditor(), flex: 5),
          ],
        ),
      ),
    );
  }
}
