part of 'team_colours_bloc.dart';

abstract class TeamColoursEvent extends Equatable {
  const TeamColoursEvent();

  @override
  List<Object> get props => [];
}

class SetTeamColour extends TeamColoursEvent {
  final String colour;
  final int team;

  SetTeamColour({required this.colour, required this.team});

  @override
  List<Object> get props => [colour, team];
}

class LoadTeamColours extends TeamColoursEvent {}