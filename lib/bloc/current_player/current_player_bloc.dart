import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:football/data/moor_database.dart';

part 'current_player_event.dart';
part 'current_player_state.dart';

class CurrentPlayerBloc extends Bloc<CurrentPlayerEvent, CurrentPlayerState> {
  CurrentPlayerBloc(Player? initialPlayer) : super(initialPlayer == null ? PlayerUnselectedState() : PlayerSelectedState(player: initialPlayer));

  @override
  Stream<CurrentPlayerState> mapEventToState(
    CurrentPlayerEvent event,
  ) async* {
    if (event is SetCurrentPlayer)
      yield PlayerSelectedState(player: event.player);
    else if (event is ClearCurrentPlayer)
      yield PlayerUnselectedState();
    //else if (event is UpdatePlayer) {
    //  if (state is PlayerSelectedState) {
    //    final currentPlayer = (state as PlayerSelectedState).player;
    //    // TODO: Tidy
    //    yield PlayerSelectedState(
    //      player: Player(
    //        id: currentPlayer.id,
    //        colour: event.player.colour.present ? event.player.colour.value : currentPlayer.colour,
    //        name: event.player.name.present ? event.player.name.value : currentPlayer.name,
    //        number: event.player.number.present ? event.player.number.value : currentPlayer.number,
    //        preferedPosition: event.player.preferedPosition.present ? event.player.preferedPosition.value : currentPlayer.preferedPosition,
    //        score: event.player.score.present ? event.player.score.value : currentPlayer.score,
    //      ),
    //    );
    //  }
    //}
  }
}
