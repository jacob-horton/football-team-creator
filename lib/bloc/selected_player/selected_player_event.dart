part of 'selected_player_bloc.dart';

abstract class SelectedPlayersEvent extends Equatable {
  const SelectedPlayersEvent();

  @override
  List<Object> get props => [];
}

class SetSelectedPlayer extends SelectedPlayersEvent {
  final EditablePlayer player;

  SetSelectedPlayer({required this.player});

  @override
  List<Object> get props => [player];
}

class AddSelectedPlayer extends SelectedPlayersEvent {
  final EditablePlayer player;

  AddSelectedPlayer({required this.player});

  @override
  List<Object> get props => [player];
}

class RemoveSelectedPlayer extends SelectedPlayersEvent {
  final EditablePlayer player;

  RemoveSelectedPlayer({required this.player});

  @override
  List<Object> get props => [player];
}

class UpdateSelectedPlayer extends SelectedPlayersEvent {
  final EditablePlayer player;

  UpdateSelectedPlayer({required this.player});

  @override
  List<Object> get props => [player];
}

class NewPlayer extends SelectedPlayersEvent {}
class ClearSelectedPlayer extends SelectedPlayersEvent {}