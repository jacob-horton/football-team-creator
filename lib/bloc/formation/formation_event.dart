part of 'formation_bloc.dart';

@immutable
abstract class FormationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPositions extends FormationEvent {}

class SetCustomFormation extends FormationEvent {
  final List<PlayerWithPosition>? players;
  SetCustomFormation({this.players});

  @override
  List<Object?> get props => [players];
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

  SetFixedFormation({required this.formation, required this.windowSize});
  @override
  List<Object?> get props => [formation, windowSize];
}

class SaveFormation extends FormationEvent {}
