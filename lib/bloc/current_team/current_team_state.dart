part of 'current_team_bloc.dart';

class CurrentTeamState extends Equatable {
  final int team;

  const CurrentTeamState({required this.team});
  
  @override
  List<Object> get props => [team];
}