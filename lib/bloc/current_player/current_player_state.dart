part of 'current_player_bloc.dart';

abstract class CurrentPlayerState extends Equatable {
  const CurrentPlayerState();
  
  @override
  List<Object> get props => [];
}

class PlayerSelectedState extends CurrentPlayerState {
  final Player player;

  const PlayerSelectedState({required this.player});
  
  @override
  List<Object> get props => [player];
}

class PlayerUnselectedState extends CurrentPlayerState {}