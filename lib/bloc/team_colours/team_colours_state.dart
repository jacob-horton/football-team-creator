part of 'team_colours_bloc.dart';

class TeamColoursState extends Equatable {
  final List<String> teamColours;

  const TeamColoursState({required this.teamColours});
  
  @override
  List<Object> get props => [teamColours];
}
