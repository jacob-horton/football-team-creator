import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/utils/formation_generator.dart';
import 'package:football/widgets/player_draggable.dart';
import 'package:meta/meta.dart';
import 'package:moor/moor.dart';

part 'formation_event.dart';
part 'formation_state.dart';

class FormationBloc extends Bloc<FormationEvent, FormationState> {
  final Random rand = Random();

  final CurrentPlayerDao currentPlayerDao;
  final PlayerDao playerDao;

  FormationBloc({required this.currentPlayerDao, required this.playerDao}) : super(FormationCustom(players: [])) {
    add(LoadPositions());
  }

  @override
  Stream<FormationState> mapEventToState(
    FormationEvent event,
  ) async* {
    if (event is LoadPositions) {
      final players = await currentPlayerDao.getAllPlayers();
      yield FormationCustom(players: players);
    } else if (event is SetCustomFormation) {
      yield FormationCustom(players: state.players);
    } else if (event is SetFixedFormation) {
      const double border = 50;
      final Offset windowSize = (event.windowSize - Size(border * 2, border * 2)) as Offset;
      final horizontalSpacing = windowSize.dx / event.formation.length.toDouble();

      final List<PlayerWithPosition> newPositions = [];
      final playersOnTeam = state.players.where((player) => player.position.team == event.team).toList();

      List<int> spacesLeft = List.from(event.formation);
      List<PlayerWithPosition> playersLeft = List.from(playersOnTeam);

      while (playersLeft.isNotEmpty) {
        final player = playersLeft[rand.nextInt(playersLeft.length)];
        playersLeft.remove(player);

        final double row = (player.player.preferedPosition / 2) * event.formation.length;

        int closestRow = -1;
        double closestDist = double.infinity;
        for (int i = 0; i < spacesLeft.length; i++) {
          if (spacesLeft[i] > 0) {
            final distToRow = (i - row).abs();
            if (distToRow < closestDist) {
              closestRow = i;
              closestDist = distToRow;
            }
          }
        }

        int j = event.formation[closestRow] - spacesLeft[closestRow];
        spacesLeft[closestRow]--;

        final verticalSpacing = windowSize.dy / event.formation[closestRow].toDouble();

        final newPlayerPosition = PlayerWithPosition(
          player: player.player,
          position: player.position.copyWith(
            x: horizontalSpacing * closestRow + horizontalSpacing / 2 - PlayerDraggable.size / 2 + border,
            y: verticalSpacing * j + verticalSpacing / 2 - PlayerDraggable.size / 2 + border,
          ),
        );

        newPositions.add(newPlayerPosition);
      }

      newPositions.addAll(state.players.where((player) => player.position.team != event.team).toList());
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
      currentPlayerDao.removeAllPlayers();
      for (final player in state.players) {
        currentPlayerDao.insertPlayer(player.position);
      }
    } else if (event is AddPlayer) {
      currentPlayerDao.insertPlayer(event.player);
    } else if (event is SwapPlayer) {
      final swapIndex = state.players.indexWhere((player) => player.player.id == event.oldPlayer.player.id);
      final List<PlayerWithPosition> newPositions = List.from(state.players);
      newPositions[swapIndex] = new PlayerWithPosition(player: event.newPlayer, position: event.oldPlayer.position);

      if (state is FormationFixed)
        yield FormationFixed(formation: (state as FormationFixed).formation, players: newPositions);
      else
        yield FormationCustom(players: newPositions);

      add(SaveFormation());
    } else if (event is SetTeams) {
      if (state is FormationFixed) {
        List<PlayerWithPosition> team1 = event.players.where((p) => p.position.team == 1).toList();
        List<PlayerWithPosition> team2 = event.players.where((p) => p.position.team == 2).toList();
        if (event.windowSize != null) _updateFormation(team1.length, event.players.length - team1.length, event.windowSize as Size);
        else {
          add(SetCustomFormation(team: 1, players: team1));
          add(SetCustomFormation(team: 2, players: team2));
        }

        yield FormationFixed(formation: (state as FormationFixed).formation, players: event.players);
      } else {
        yield FormationCustom(players: event.players);

        List<PlayerWithPosition> team1 = event.players.where((p) => p.position.team == 1).toList();
        List<PlayerWithPosition> team2 = event.players.where((p) => p.position.team == 2).toList();
        if (event.windowSize != null) _updateFormation(team1.length, event.players.length - team1.length, event.windowSize as Size);
        else {
          add(SetCustomFormation(team: 1, players: team1));
          add(SetCustomFormation(team: 2, players: team2));
        }
      }

      add(SaveFormation());
    } else if (event is ChangePlayerTeam) {
      // TODO: Is there a more efficient way
      final oldTeam = event.playerPosition.team;
      final newTeam = oldTeam == 1 ? 2 : 1;

      final playerToUpdate = state.players.firstWhere((player) => player.player.id == event.playerPosition.playerId);
      final newPlayer = PlayerWithPosition(player: playerToUpdate.player, position: playerToUpdate.position.copyWith(team: newTeam));
      final List<PlayerWithPosition> newPositions = List.from(state.players);

      newPositions[newPositions.indexOf(playerToUpdate)] = newPlayer;

      add(SetTeams(players: newPositions, windowSize: event.windowSize));
    } else if (event is RemovePlayer) {
      final List<PlayerWithPosition> newPositions = List.from(state.players);

      for (final player in newPositions) {
        if (player.player.id == event.player.id) {
          newPositions.remove(player);
          break;
        }
      }

      currentPlayerDao.deletePlayerFromID(event.player.id);
      add(SetTeams(players: newPositions, windowSize: event.windowSize));
    } else if (event is ShufflePlayers) {
      final List<Player> players = List.from(event.players ?? state.players.map((player) => player.player));
      List<PlayerWithPosition> newPositions = _simulatedAnnealing(players);

      add(SetTeams(players: newPositions, windowSize: event.windowSize));
    } else if (event is PermenantlyDeletePlayer) {
      final List<PlayerWithPosition> newPositions = List.from(state.players);

      for (final player in newPositions) {
        if (player.player.id == event.player.id) {
          newPositions.remove(player);
          break;
        }
      }

      currentPlayerDao.deletePlayerFromID(event.player.id);
      playerDao.deletePlayerFromID(event.player.id);
      add(SetTeams(players: newPositions, windowSize: event.windowSize));
    }
  }

  _updateFormation(int team1Size, int team2Size, Size windowSize) {
    List<int> team1Formation = FormationGenerator.getFormations(team1Size)[0];
    List<int> team2Formation = FormationGenerator.getFormations(team2Size)[0];
    add(SetFixedFormation(formation: team1Formation, windowSize: windowSize, team: 1));
    add(SetFixedFormation(formation: team2Formation, windowSize: windowSize, team: 2));
  }

  final maxIterations = 10;
  final initialPosition = PlayerPosition(playerId: 0, team: 1, x: 0, y: 0);
  List<PlayerWithPosition> _simulatedAnnealing(List<Player> players) {
    List<PlayerWithPosition> bestPlayers = _getInitialState(players);
    if (bestPlayers.length < 2) return bestPlayers; // If there are 0 or 1 players, then they don't need to be shuffled

    double s = _getScore(bestPlayers);

    int iterationsSinceImprovement = 0;
    int i = 0;

    while (iterationsSinceImprovement < maxIterations) {
      iterationsSinceImprovement++;

      double t = 1 / exp(i);
      List<PlayerWithPosition> neighbour = _getNeighbour(bestPlayers);
      double sNew = _getScore(neighbour);

      if (_getAcceptanceProbability(s, sNew, t) >= rand.nextDouble()) {
        iterationsSinceImprovement = 0;
        bestPlayers = neighbour;
        s = sNew;
      }

      i++;
    }

    return bestPlayers;
  }

  List<PlayerWithPosition> _getInitialState(List<Player> players) {
    List<Player> shuffled = List.from(players)..shuffle(rand);
    List<PlayerWithPosition> initialState = [];

    for (int i = 0; i < shuffled.length; i++) {
      int team = i < shuffled.length / 2 ? 1 : 2;
      initialState.add(PlayerWithPosition(player: shuffled[i], position: initialPosition.copyWith(team: team, playerId: shuffled[i].id)));
    }

    return initialState;
  }

  List<PlayerWithPosition> _getNeighbour(List<PlayerWithPosition> players) {
    List<PlayerWithPosition> playersCopy = List.from(players);
    List<PlayerWithPosition> team1 = playersCopy.where((p) => p.position.team == 1).toList();
    List<PlayerWithPosition> team2 = playersCopy.where((p) => p.position.team == 2).toList();

    PlayerWithPosition team1Player = team1[rand.nextInt(team1.length)];
    PlayerWithPosition team2Player = team2[rand.nextInt(team2.length)];

    playersCopy[playersCopy.indexOf(team1Player)] = PlayerWithPosition(player: team1Player.player, position: team1Player.position.copyWith(team: 2));
    playersCopy[playersCopy.indexOf(team2Player)] = PlayerWithPosition(player: team2Player.player, position: team2Player.position.copyWith(team: 1));

    return playersCopy;
  }

  double _getScore(List<PlayerWithPosition> players) {
    int team1Score = 0;
    int team2Score = 0;

    for (final player in players) {
      if (player.position.team == 1)
        team1Score += player.player.score;
      else
        team2Score += player.player.score;
    }

    return (team1Score - team2Score).abs().toDouble();
  }

  double _getAcceptanceProbability(double e, double eNew, double t) {
    if (eNew < e) return 1;
    return exp(-(eNew - e) / t);
  }
}

