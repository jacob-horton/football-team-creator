part of 'selected_player_bloc.dart';

abstract class SelectedPlayersState extends Equatable {
  const SelectedPlayersState();
  
  @override
  List<Object> get props => [];
}

class SingleSelectionState extends SelectedPlayersState {
  final Player player;

  const SingleSelectionState({required this.player});
  
  @override
  List<Object> get props => [player];
}

class MultiSelectionState extends SelectedPlayersState {
  final List<Player> players;
  final Player? selected;

  const MultiSelectionState({required this.players, this.selected});
  
  @override
  List<Object> get props => selected == null ? [players] : [players, selected as Object];
}

class NewPlayerState extends SelectedPlayersState {}
class PlayerUnselectedState extends SelectedPlayersState {}