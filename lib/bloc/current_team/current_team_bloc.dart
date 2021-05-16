import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'current_team_event.dart';
part 'current_team_state.dart';

class CurrentTeamBloc extends Bloc<CurrentTeamEvent, CurrentTeamState> {
  CurrentTeamBloc() : super(CurrentTeamState(team: 1));

  @override
  Stream<CurrentTeamState> mapEventToState(
    CurrentTeamEvent event,
  ) async* {
    if (event is SetCurrentTeam) {
      yield CurrentTeamState(team: event.team);
    }
  }
}
