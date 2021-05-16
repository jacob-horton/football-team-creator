import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/widgets/player_draggable.dart';
import 'package:meta/meta.dart';

part 'formation_event.dart';
part 'formation_state.dart';

class FormationBloc extends Bloc<FormationEvent, FormationState> {
  final CurrentPlayerDao dao;
  FormationBloc({required this.dao}) : super(FormationCustom(players: [])) {
    add(LoadPositions());
  }

  @override
  Stream<FormationState> mapEventToState(
    FormationEvent event,
  ) async* {
    if (event is LoadPositions) {
      yield FormationCustom(players: await dao.getAllPlayers());
    } else if (event is SetCustomFormation) {
      yield FormationCustom(players: event.players ?? state.players);
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
          final player = state.players[index];

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

      yield FormationFixed(formation: event.formation, players: newPositions);
    } else if (event is SetPlayerPosition) {
      final playerToChange = state.players.firstWhere((player) => player.player.id == event.playerPosition.playerId);
      final index = state.players.indexOf(playerToChange);

      final newPositions = List<PlayerWithPosition>.from(state.players);
      newPositions[index] = PlayerWithPosition(
        player: playerToChange.player,
        position: playerToChange.position.copyWith(
          x: event.playerPosition.x,
          y: event.playerPosition.y,
        ),
      );

      yield FormationCustom(players: newPositions);
    } else if (event is SaveFormation) {
      dao.updatePlayers(state.players.map((playerWithPosition) => playerWithPosition.position).toList());
    }
  }
}
