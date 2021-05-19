import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:football/data/moor_database.dart';

part 'selected_player_event.dart';
part 'selected_player_state.dart';

class SelectedPlayersBloc extends Bloc<SelectedPlayersEvent, SelectedPlayersState> {
  SelectedPlayersBloc(List<Player>? initialPlayers) : super(PlayerUnselectedState()) {
    if (initialPlayers == null) {
      add(ClearSelectedPlayer());
    } else {
      if (initialPlayers.length == 1)
        add(SetSelectedPlayer(player: EditablePlayer.fromPlayer(initialPlayers.first)));
      else {
        for (final player in initialPlayers)
          add(AddSelectedPlayer(player: EditablePlayer.fromPlayer(player)));
      }
    }
  }

  @override
  Stream<SelectedPlayersState> mapEventToState(
    SelectedPlayersEvent event,
  ) async* {
    if (event is SetSelectedPlayer) {
      if (state is NewPlayerState) yield NewPlayerState(player: event.player);
      else yield SingleSelectionState(player: event.player);
    }else if (event is ClearSelectedPlayer)
      yield PlayerUnselectedState();
    else if (event is AddSelectedPlayer) {
      List<EditablePlayer> players = [];
      if (state is MultiSelectionState)
        players = List.from((state as MultiSelectionState).players);
      else if (state is SingleSelectionState) players = [(state as SingleSelectionState).selectedPlayer as EditablePlayer];
      else if (state is NewPlayerState) players = [(state as NewPlayerState).selectedPlayer as EditablePlayer];
      players.add(event.player);

      yield MultiSelectionState(players: players);
    } else if (event is RemoveSelectedPlayer) {
      List<EditablePlayer> players = [];
      if (state is MultiSelectionState) {
        players = List.from((state as MultiSelectionState).players);
        players.removeWhere((player) => player.id == event.player.id);
      }

      if (players.isEmpty)
        yield PlayerUnselectedState();
      else
        yield MultiSelectionState(players: players);
    } else if (event is NewPlayer) {
      yield NewPlayerState(player: EditablePlayer());
    }
  }
}
