import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/formation/formation_bloc.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/pages/player_selector.dart';
import 'package:football/utils/navigation.dart';
import 'package:football/widgets/player_list_item.dart';

class TeamEditor extends StatelessWidget {
  TeamEditor({Key? key}) : super(key: key);

  final Random rand = Random();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormationBloc, FormationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xfff5f5f5),
          body: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildTeam(context, state, 1)),
                    VerticalDivider(width: 0, endIndent: 10, indent: 10),
                    Expanded(child: _buildTeam(context, state, 2)),
                  ],
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      final List<PlayerWithPosition> currentPlayers = List.from(state.teams[0])..addAll(state.teams[1]);

                      final Object? newPlayers = await Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (_) => PlayerSelector(
                            multiselect: true,
                            initialPlayers: currentPlayers.map((player) => player.player).toList(),
                          ),
                        ),
                      );
                      if (newPlayers is List<Player>) _suffleTeams2(state, context, newPlayers);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('SELECT PLAYERS'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: move to bloc
                      _suffleTeams(state, context, List.from(state.teams[0])..addAll(state.teams[1]));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('SHUFFLE TEAMS'),
                    ),
                  ),
                  Expanded(child: Container()),
                  TextButton(onPressed: () => Navigation.pop(context), child: Text('DONE')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // TODO: Remove duplicate function
  void _suffleTeams2(FormationState state, BuildContext context, List<Player> players) {
    List<PlayerWithPosition> team1 = [];
    List<PlayerWithPosition> team2 = [];

    int team1Score = 0;
    int team2Score = 0;

    final position = PlayerPosition(playerId: 0, team: 1, x: 100, y: 100);

    while (players.length > 0) {
      final randomPlayer = players[rand.nextInt(players.length)];
      final player1 = PlayerWithPosition(player: randomPlayer, position: position.copyWith(playerId: randomPlayer.id, team: 1));

      team1.add(player1);
      players.remove(randomPlayer);
      if (players.length == 0) break;

      team1Score += player1.player.score;
      final scoreDifference = team1Score - team2Score;

      final possiblePlayers = players.where((p) => (p.score - scoreDifference).abs() <= 2).toList(); // TODO: Adjust threshold

      // If no players within threshold, get the one with the closest score
      if (possiblePlayers.length == 0) {
        int bestScore = (players[0].score - scoreDifference).abs();
        Player bestPlayer = players[0];
        for (int i = 1; i < players.length; i++) {
          final score = (players[i].score - scoreDifference).abs();
          if (score < bestScore) {
            bestScore = score;
            bestPlayer = players[i];
          }
        }

        final player2 = PlayerWithPosition(player: bestPlayer, position: position.copyWith(playerId: bestPlayer.id, team: 2));
        team2.add(player2);
        players.remove(bestPlayer);

        team2Score += player2.player.score;
      } else {
        final randomPlayer = possiblePlayers[rand.nextInt(possiblePlayers.length)];
        final player2 = PlayerWithPosition(player: randomPlayer, position: position.copyWith(playerId: randomPlayer.id, team: 2));

        team2.add(player2);
        players.remove(randomPlayer);

        team2Score += player2.player.score;
      }
    }

    BlocProvider.of<FormationBloc>(context, listen: false).add(SetTeams(teams: [team1, team2]));
  }

  // TODO: Handle uneven number of players better
  void _suffleTeams(FormationState state, BuildContext context, List<PlayerWithPosition> players) {
    List<PlayerWithPosition> team1 = [];
    List<PlayerWithPosition> team2 = [];

    int team1Score = 0;
    int team2Score = 0;

    while (players.length > 0) {
      final randomPlayer = players[rand.nextInt(players.length)];
      final player1 = PlayerWithPosition(player: randomPlayer.player, position: randomPlayer.position.copyWith(team: 1));

      team1.add(player1);
      players.remove(randomPlayer);
      if (players.length == 0) break;

      team1Score += player1.player.score;
      final scoreDifference = team1Score - team2Score;

      final possiblePlayers = players.where((p) => (p.player.score - scoreDifference).abs() <= 2).toList(); // TODO: Adjust threshold

      // If no players within threshold, get the one with the closest score
      if (possiblePlayers.length == 0) {
        int bestScore = (players[0].player.score - scoreDifference).abs();
        PlayerWithPosition bestPlayer = players[0];
        for (int i = 1; i < players.length; i++) {
          final score = (players[i].player.score - scoreDifference).abs();
          if (score < bestScore) {
            bestScore = score;
            bestPlayer = players[i];
          }
        }

        final player2 = PlayerWithPosition(player: bestPlayer.player, position: bestPlayer.position.copyWith(team: 2));
        team2.add(player2);
        players.remove(bestPlayer);

        team2Score += player2.player.score;
      } else {
        final randomPlayer = possiblePlayers[rand.nextInt(possiblePlayers.length)];
        final player2 = PlayerWithPosition(player: randomPlayer.player, position: randomPlayer.position.copyWith(team: 2));

        team2.add(player2);
        players.remove(randomPlayer);

        team2Score += player2.player.score;
      }
    }

    BlocProvider.of<FormationBloc>(context, listen: false).add(SetTeams(teams: [team1, team2]));
  }

  Widget _buildTeam(BuildContext context, FormationState state, int teamNumber) {
    final players = state.teams[teamNumber - 1];

    return DragTarget<PlayerWithPosition>(
      onAccept: (player) {
        if (teamNumber != player.position.team)
          BlocProvider.of<FormationBloc>(context).add(
            ChangePlayerTeam(playerPosition: player.position),
          );
      },
      builder: (context, _, __) => Column(
        children: [
          Text('Team ${teamNumber.toString()}'),
          Expanded(
            child: ListView(
              children: players.map(
                (player) {
                  final listItem = PlayerListItem(
                    player: player.player,
                    onTap: (_) async {
                      Object? newPlayer = await Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (context) => PlayerSelector(
                            multiselect: false,
                            initialPlayers: [player.player],
                          ),
                        ),
                      );

                      if (newPlayer is Player) BlocProvider.of<FormationBloc>(context).add(SwapPlayer(oldPlayer: player, newPlayer: newPlayer));
                    },
                  );

                  return Draggable<PlayerWithPosition>(
                    childWhenDragging: Container(),
                    feedback: Material(child: listItem, type: MaterialType.transparency),
                    child: listItem,
                    data: player,
                  );
                },
              ).toList(),
            ),
          ),
          Text('Score: ${players.length == 0 ? 0 : players.map((player) => player.player.score).reduce((a, b) => a + b)}'),
        ],
      ),
    );
  }
}
