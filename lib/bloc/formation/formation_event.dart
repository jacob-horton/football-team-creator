part of 'formation_bloc.dart';

@immutable
abstract class FormationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPositions extends FormationEvent {}

class SetCustomFormation extends FormationEvent {
  final List<PlayerWithPosition>? players;
  final int team;

  SetCustomFormation({required this.team, this.players});

  @override
  List<Object?> get props => [team, players];
}

class SetPlayerPosition extends FormationEvent {
  final PlayerPosition playerPosition;
  SetPlayerPosition({required this.playerPosition});

  @override
  List<Object?> get props => [playerPosition];
}

class SetFixedFormation extends FormationEvent {
  final List<int> formation;
  final Size windowSize;
  final int team;

  SetFixedFormation({required this.formation, required this.windowSize, required this.team});

  @override
  List<Object?> get props => [formation, windowSize, team];
}

class AddPlayer extends FormationEvent {
  final Insertable<PlayerPosition> player;

  AddPlayer({required this.player});

  @override
  List<Object?> get props => [player];
}

class SwapPlayer extends FormationEvent {
  final PlayerWithPosition oldPlayer;
  final Player newPlayer;

  SwapPlayer({required this.oldPlayer, required this.newPlayer});

  @override
  List<Object?> get props => [oldPlayer, newPlayer];
}

class SaveFormation extends FormationEvent {}
