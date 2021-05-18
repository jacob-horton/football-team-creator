part of 'current_player_bloc.dart';

abstract class CurrentPlayerEvent extends Equatable {
  const CurrentPlayerEvent();

  @override
  List<Object> get props => [];
}

class SetCurrentPlayer extends CurrentPlayerEvent {
  final Player player;

  SetCurrentPlayer({required this.player});

  @override
  List<Object> get props => [player];
}

//class UpdatePlayer extends CurrentPlayerEvent {
//  final PlayersCompanion player;
//
//  UpdatePlayer({required this.player});
//
//  @override
//  List<Object> get props => [player];
//}

class ClearCurrentPlayer extends CurrentPlayerEvent {}