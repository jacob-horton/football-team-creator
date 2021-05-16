part of 'current_team_bloc.dart';

abstract class CurrentTeamEvent extends Equatable {
  const CurrentTeamEvent();

  @override
  List<Object> get props => [];
}

class SetCurrentTeam extends CurrentTeamEvent {
  final int team;

  SetCurrentTeam({required this.team});

  @override
  List<Object> get props => [];
}