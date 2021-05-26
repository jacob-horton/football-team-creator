part of 'selected_player_bloc.dart';

abstract class SelectedPlayersState extends Equatable {
  final EditablePlayer? selectedPlayer;

  SelectedPlayersState({this.selectedPlayer});

  @override
  List<Object> get props => selectedPlayer == null ? [] : [selectedPlayer as Object];
}

class SingleSelectionState extends SelectedPlayersState {
  SingleSelectionState({required EditablePlayer player}) : super(selectedPlayer: player);
}

class MultiSelectionState extends SelectedPlayersState {
  final List<EditablePlayer> players;

  MultiSelectionState({required this.players}) : super(selectedPlayer: players.length == 0 ? null : players.last);

  @override
  List<Object> get props => selectedPlayer == null ? [players] : [players, selectedPlayer as Object];
}

class NewPlayerState extends SelectedPlayersState {
  NewPlayerState({required EditablePlayer player}) : super(selectedPlayer: player);
}

class PlayerUnselectedState extends SelectedPlayersState {}

class EditablePlayer {
  int? id;
  String? name;
  int? number;
  int? score;
  int? preferredPosition;

  EditablePlayer({this.id, this.name, this.number, this.score, this.preferredPosition});

  static EditablePlayer fromPlayer(Player player) {
    return EditablePlayer(
      id: player.id,
      name: player.name,
      number: player.number,
      preferredPosition: player.preferredPosition,
      score: player.score,
    );
  }
  static EditablePlayer fromPlayersCompanion(PlayersCompanion player) {
    return EditablePlayer(
      id: player.id.present ? player.id.value : null,
      name: player.name.present ? player.name.value : null,
      number: player.number.present ? player.number.value : null,
      preferredPosition: player.preferredPosition.present ? player.preferredPosition.value : null,
      score: player.score.present ? player.score.value : null,
    );
  }

  EditablePlayer copyWith({String? name, String? colour, int? number, int? score, int? preferredPosition}) {
    return EditablePlayer(
      id: this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      score: score ?? this.score,
      preferredPosition: preferredPosition ?? this.preferredPosition,
    );
  }

  Player? toPlayer() {
    if (id == null || name == null || number == null || preferredPosition == null || score == null) return null;

    return Player(
      id: id as int,
      name: name as String,
      score: score as int,
      number: number as int,
      preferredPosition: preferredPosition as int,
    );
  }
}
