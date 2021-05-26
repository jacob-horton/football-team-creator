import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'team_colours_event.dart';
part 'team_colours_state.dart';

class TeamColoursBloc extends Bloc<TeamColoursEvent, TeamColoursState> {
  static const key = 'team_colours';
  static const defaultValues = ['red', 'blue'];

  TeamColoursBloc() : super(TeamColoursState(teamColours: defaultValues)) {
    add(LoadTeamColours());
  }

  @override
  Stream<TeamColoursState> mapEventToState(
    TeamColoursEvent event,
  ) async* {
    final prefs = await SharedPreferences.getInstance();

    if (event is SetTeamColour) {
      List<String> newColours = List.from(state.teamColours);
      newColours[event.team - 1] = event.colour;

      prefs.setStringList(key, newColours);
      yield TeamColoursState(teamColours: newColours);
    } else if (event is LoadTeamColours) {
      yield TeamColoursState(teamColours: prefs.getStringList(key) ?? defaultValues);
    }
  }
}
