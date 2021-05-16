part of 'formation_bloc.dart';

@immutable
abstract class FormationState extends Equatable {
  final List<PlayerWithPosition> players;

  FormationState(this.players);

  @override
  List<Object?> get props => [players];
}

class FormationFixed extends FormationState {
  final List<int> formation;

  FormationFixed({required this.formation, required List<PlayerWithPosition> players}) : super(players);

  @override
  List<Object?> get props => [formation, players];
}

class FormationCustom extends FormationState {
  FormationCustom({required List<PlayerWithPosition> players}) : super(players);
}
