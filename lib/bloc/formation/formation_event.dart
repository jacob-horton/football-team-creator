part of 'formation_bloc.dart';

// TODO: rename classes to now use 'player' not 'team'
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

class AdjustPlayerPosition extends FormationEvent {
  final int playerId;
  final Offset delta;

  AdjustPlayerPosition({required this.playerId, required this.delta});

  @override
  List<Object?> get props => [playerId, delta];
}

class SetFixedFormation extends FormationEvent {
  final List<int> formation;
  final Size windowSize;
  final int team;
  final bool saveFormation;

  SetFixedFormation({required this.formation, required this.windowSize, required this.team, this.saveFormation = true});

  @override
  List<Object?> get props => [formation, windowSize, team];
}

class AddPlayer extends FormationEvent {
  final Insertable<PlayerPosition> player;

  AddPlayer({required this.player});

  @override
  List<Object?> get props => [player];
}

class RemovePlayer extends FormationEvent {
  final Player player;
  final Size windowSize;

  RemovePlayer({required this.player, required this.windowSize});

  @override
  List<Object?> get props => [player, windowSize];
}

class PermenantlyDeletePlayer extends FormationEvent {
  final Player player;
  final Size windowSize;

  PermenantlyDeletePlayer({required this.player, required this.windowSize});

  @override
  List<Object?> get props => [player, windowSize];
}

class SetTeams extends FormationEvent {
  final List<PlayerWithPosition> players;
  final Size? windowSize;
  final bool havePlayersChanged;

  SetTeams({required this.players, this.windowSize, required this.havePlayersChanged});

  @override
  List<Object?> get props => [players, windowSize, havePlayersChanged];
}

class SwapPlayer extends FormationEvent {
  final PlayerWithPosition oldPlayer;
  final Player newPlayer;

  SwapPlayer({required this.oldPlayer, required this.newPlayer});

  @override
  List<Object?> get props => [oldPlayer, newPlayer];
}

class ChangePlayerTeam extends FormationEvent {
  final PlayerPosition playerPosition;
  final Size windowSize;

  ChangePlayerTeam({required this.playerPosition, required this.windowSize});

  @override
  List<Object?> get props => [playerPosition, windowSize];
}

class ShufflePlayers extends FormationEvent {
  final List<Player>? players;
  final Size windowSize;

  ShufflePlayers({this.players, required this.windowSize});

  @override
  List<Object?> get props => [players, windowSize];
}

class SaveFormation extends FormationEvent {
  final bool havePlayersChanged;

  SaveFormation({required this.havePlayersChanged});

  @override
  List<Object?> get props => [havePlayersChanged];
}