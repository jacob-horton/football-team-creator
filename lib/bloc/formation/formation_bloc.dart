import 'dart:async';
import 'dart:math';

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
  final Random rand = Random();

  final CurrentPlayerDao dao;
  FormationBloc({required this.dao}) : super(FormationCustom(players: [])) {
    add(LoadPositions());
  }

  @override
  Stream<FormationState> mapEventToState(
    FormationEvent event,
  ) async* {
    if (event is LoadPositions) {
      final players = await dao.getAllPlayers();
      yield FormationCustom(players: players);
    } else if (event is SetCustomFormation) {
      yield FormationCustom(players: state.players);
    } else if (event is SetFixedFormation) {
      const double border = 50;
      final Offset windowSize = (event.windowSize - Size(border * 2, border * 2)) as Offset;
      final horizontalSpacing = windowSize.dx / event.formation.length.toDouble();

      final List<PlayerWithPosition> newPositions = List.from(state.players);
      final playersOnTeam = state.players.where((player) => player.position.team == event.team).toList();

      int index = 0;
      for (int i = 0; i < event.formation.length; i++) {
        final verticalSpacing = windowSize.dy / event.formation[i].toDouble();
        for (int j = 0; j < event.formation[i]; j++) {
          // TODO: Get random player with correct preferred position
          final player = playersOnTeam[index];

          newPositions[newPositions.indexOf(player)] = PlayerWithPosition(
            player: player.player,
            position: player.position.copyWith(
              x: horizontalSpacing * i + horizontalSpacing / 2 - PlayerDraggable.size / 2 + border,
              y: verticalSpacing * j + verticalSpacing / 2 - PlayerDraggable.size / 2 + border,
            ),
          );

          index++;
        }
      }

      yield FormationFixed(formation: event.formation, players: newPositions);
      add(SaveFormation());
    } else if (event is SetPlayerPosition) {
      int index = state.players.indexWhere((player) => player.player.id == event.playerPosition.playerId);

      final newPositions = List<PlayerWithPosition>.from(state.players);
      newPositions[index] = PlayerWithPosition(
        player: state.players[index].player,
        position: state.players[index].position.copyWith(
          x: event.playerPosition.x,
          y: event.playerPosition.y,
        ),
      );

      yield FormationCustom(players: newPositions);
    } else if (event is AdjustPlayerPosition) {
      int index = state.players.indexWhere((player) => player.player.id == event.playerId);

      final newPositions = List<PlayerWithPosition>.from(state.players);
      final oldPosition = state.players[index].position;
      newPositions[index] = PlayerWithPosition(
        player: state.players[index].player,
        position: state.players[index].position.copyWith(
          x: oldPosition.x + event.delta.dx,
          y: oldPosition.y + event.delta.dy,
        ),
      );

      yield FormationCustom(players: newPositions);
    } else if (event is SaveFormation) {
      dao.removeAllPlayers();
      for (final player in state.players) {
        dao.insertPlayer(player.position);
      }
    } else if (event is AddPlayer) {
      dao.insertPlayer(event.player);
    } else if (event is SwapPlayer) {
      // TODO: Error swapping player when duplicate player in team
      final swapIndex = state.players.indexWhere((player) => player.player.id == event.oldPlayer.player.id);
      final List<PlayerWithPosition> newPositions = List.from(state.players);
      newPositions[swapIndex] = new PlayerWithPosition(player: event.newPlayer, position: event.oldPlayer.position);

      if (state is FormationFixed)
        yield FormationFixed(formation: (state as FormationFixed).formation, players: newPositions);
      else
        yield FormationCustom(players: newPositions);

      add(SaveFormation());
    } else if (event is SetTeams) {
      if (state is FormationFixed)
        yield FormationFixed(formation: (state as FormationFixed).formation, players: event.players);
      else
        yield FormationCustom(players: event.players);

      add(SaveFormation());
    } else if (event is ChangePlayerTeam) {
      // TODO: Is there a more efficient way
      final oldTeam = event.playerPosition.team;
      final newTeam = oldTeam == 1 ? 2 : 1;

      final playerToUpdate = state.players.firstWhere((player) => player.player.id == event.playerPosition.playerId);
      final newPlayer = PlayerWithPosition(player: playerToUpdate.player, position: playerToUpdate.position.copyWith(team: newTeam));
      final List<PlayerWithPosition> newPositions = List.from(state.players);

      newPositions[newPositions.indexOf(playerToUpdate)] = newPlayer;

      add(SetTeams(players: newPositions));
    } else if (event is RemovePlayer) {
      final List<PlayerWithPosition> newPositions = List.from(state.players);

      for (final player in newPositions) {
        if (player.player.id == event.player.id) {
          newPositions.remove(player);
          break;
        }
      }

      dao.deletePlayerFromID(event.player.id);
      add(SetTeams(players: newPositions));
    } else if (event is ShufflePlayers) {
      // TODO: Handle uneven team split
      final List<Player> players = List.from(event.players ?? state.players.map((player) => player.player));
      final List<PlayerWithPosition> newPositions = [];

      int team1Score = 0;
      int team2Score = 0;

      final position = PlayerPosition(playerId: 0, team: 1, x: 0, y: 0);

      while (players.length > 0) {
        final randomPlayer = players[rand.nextInt(players.length)];
        final player1 = PlayerWithPosition(player: randomPlayer, position: position.copyWith(playerId: randomPlayer.id, team: 1));

        newPositions.add(player1);
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
          newPositions.add(player2);
          players.remove(bestPlayer);

          team2Score += player2.player.score;
        } else {
          final randomPlayer = possiblePlayers[rand.nextInt(possiblePlayers.length)];
          final player2 = PlayerWithPosition(player: randomPlayer, position: position.copyWith(playerId: randomPlayer.id, team: 2));

          newPositions.add(player2);
          players.remove(randomPlayer);

          team2Score += player2.player.score;
        }
      }

      add(SetTeams(players: newPositions));
      //TODO: Set fixed formation (needs window size)
    }
  }
}
