part of 'formation_bloc.dart';

@immutable
abstract class FormationState extends Equatable {
  final List<List<PlayerWithPosition>> teams;

  FormationState({required this.teams});

  @override
  List<Object?> get props => [teams];
}

class FormationFixed extends FormationState {
  final List<int> formation;

  FormationFixed({required this.formation, required List<List<PlayerWithPosition>> teams}) : super(teams: teams);

  @override
  List<Object?> get props => [formation, teams];
}

class FormationCustom extends FormationState {
  FormationCustom({required List<List<PlayerWithPosition>> teams}) : super(teams: teams);
}
