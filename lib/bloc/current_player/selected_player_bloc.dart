import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:football/data/moor_database.dart';

part 'selected_player_event.dart';
part 'selected_player_state.dart';

class SelectedPlayersBloc extends Bloc<SelectedPlayersEvent, SelectedPlayersState> {
  SelectedPlayersBloc(List<Player>? initialPlayers)
      : super(
          initialPlayers == null
              ? PlayerUnselectedState()
              : initialPlayers.length == 1
                  ? SingleSelectionState(player: initialPlayers.first)
                  : MultiSelectionState(players: initialPlayers),
        );

  @override
  Stream<SelectedPlayersState> mapEventToState(
    SelectedPlayersEvent event,
  ) async* {
    if (event is SetSelectedPlayer)
      yield SingleSelectionState(player: event.player);
    else if (event is ClearSelectedPlayer)
      yield PlayerUnselectedState();
    else if (event is AddSelectedPlayer) {
      List<Player> players = [];
      if (state is MultiSelectionState) players = List.from((state as MultiSelectionState).players);
      else if (state is SingleSelectionState) players = [(state as SingleSelectionState).player];
      players.add(event.player);

      yield MultiSelectionState(players: players, selected: event.player);
    } else if (event is RemoveSelectedPlayer) {
      List<Player> players = [];
      if (state is MultiSelectionState) {
        players = List.from((state as MultiSelectionState).players);
        players.remove(event.player);
      }

      if (players.isEmpty) yield PlayerUnselectedState();
      else yield MultiSelectionState(players: players, selected: players.length == 0 ? null : players.last);
    } else if (event is NewPlayer) {
      yield NewPlayerState();
    }
  }
}
