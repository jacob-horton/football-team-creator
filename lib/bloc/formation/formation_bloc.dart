import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/widgets/player_draggable.dart';
import 'package:meta/meta.dart';
import 'package:moor/moor.dart';

part 'formation_event.dart';
part 'formation_state.dart';

class FormationBloc extends Bloc<FormationEvent, FormationState> {
  final CurrentPlayerDao dao;
  FormationBloc({required this.dao}) : super(FormationCustom(teams: [[], []])) {
    add(LoadPositions());
  }

  @override
  Stream<FormationState> mapEventToState(
    FormationEvent event,
  ) async* {
    if (event is LoadPositions) {
      final teams = [await dao.getPlayersOnTeam(1), await dao.getPlayersOnTeam(2)];
      yield FormationCustom(teams: teams);
    } else if (event is SetCustomFormation) {
      final List<List<PlayerWithPosition>> teams = List.from(state.teams);
      teams[event.team - 1] = event.players ?? teams[event.team - 1];

      yield FormationCustom(teams: teams);
    } else if (event is SetFixedFormation) {
      const double border = 50;
      Offset windowSize = (event.windowSize - Size(border * 2, border * 2)) as Offset;
      final horizontalSpacing = windowSize.dx / event.formation.length.toDouble();

      List<PlayerWithPosition> newPositions = [];
      int index = 0;
      for (int i = 0; i < event.formation.length; i++) {
        final verticalSpacing = windowSize.dy / event.formation[i].toDouble();
        for (int j = 0; j < event.formation[i]; j++) {
          // TODO: Get random player with correct preferred position
          // TODO: split into teams
          final player = state.teams[event.team - 1][index];

          newPositions.add(
            PlayerWithPosition(
              player: player.player,
              position: player.position.copyWith(
                x: horizontalSpacing * i + horizontalSpacing / 2 - PlayerDraggable.size / 2 + border,
                y: verticalSpacing * j + verticalSpacing / 2 - PlayerDraggable.size / 2 + border,
              ),
            ),
          );

          index++;
        }
      }

      final List<List<PlayerWithPosition>> teams = List.from(state.teams);
      teams[event.team - 1] = newPositions;

      yield FormationFixed(formation: event.formation, teams: teams);
      add(SaveFormation());
    } else if (event is SetPlayerPosition) {
      PlayerWithPosition? playerToChange;
      bool found = false;

      int teamIndex = 0;
      int playerIndex = 0;
      for (teamIndex = 0; teamIndex < state.teams.length; teamIndex++) {
        for (playerIndex = 0; playerIndex < state.teams[teamIndex].length; playerIndex++) {
          if (state.teams[teamIndex][playerIndex].player.id == event.playerPosition.playerId) {
            playerToChange = state.teams[teamIndex][playerIndex];
            found = true;
            break;
          }
        }
        if (found) break;
      }

      if (playerToChange == null) return; // TODO: Handle null player
      final newPositions = List<PlayerWithPosition>.from(state.teams[teamIndex]);
      newPositions[playerIndex] = PlayerWithPosition(
        player: playerToChange.player,
        position: playerToChange.position.copyWith(
          x: event.playerPosition.x,
          y: event.playerPosition.y,
        ),
      );

      final List<List<PlayerWithPosition>> teams = List.from(state.teams);
      teams[teamIndex] = newPositions;

      yield FormationCustom(teams: teams);
    } else if (event is SaveFormation) {
      for (final team in state.teams) {
        for (final player in team) {
          dao.updatePlayer(player.position);
        }
      }
    } else if (event is AddPlayer) {
      dao.insertPlayer(event.player);
    } else if (event is SwapPlayer) {
      final swapindex = state.teams[event.oldPlayer.position.team - 1].indexWhere((player) => player.player.id == event.oldPlayer.player.id);
      final List<List<PlayerWithPosition>> newTeams = List.from(state.teams);
      final List<PlayerWithPosition> newPlayers = List.from(state.teams[event.oldPlayer.position.team - 1]);

      newPlayers[swapindex] = new PlayerWithPosition(player: event.newPlayer, position: event.oldPlayer.position);
      newTeams[event.oldPlayer.position.team - 1] = newPlayers;

      if (state is FormationFixed)
        yield FormationFixed(formation: (state as FormationFixed).formation, teams: newTeams);
      else
        yield FormationCustom(teams: newTeams);

      add(SaveFormation());
    }
  }
}
